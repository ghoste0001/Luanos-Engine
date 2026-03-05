/**********************************************************************************************
*
* raylibExtras * Utilities and Shared Components for Raylib
*
* RLAssets * Simple Asset Managment System for Raylib
*
* LICENSE: MIT
*
**********************************************************************************************/
// had to modify this cause it was originally for cpp

#include "rlFrustum.h"
#include "rlgl.h"
#include <math.h>
#include <stdlib.h>

// helper functions
static void NormalizePlane(Vector4* plane)
{
    float magnitude = sqrtf(plane->x * plane->x + plane->y * plane->y + plane->z * plane->z);

    if (magnitude > 0.0f) 
    {
        plane->x /= magnitude;
        plane->y /= magnitude;
        plane->z /= magnitude;
        plane->w /= magnitude;
    }
}

static float DistanceToPlane(const Vector4 plane, const Vector3 position)
{
    return (plane.x * position.x + plane.y * position.y + plane.z * position.z + plane.w);
}

static float DistanceToPlaneXYZ(const Vector4 plane, float x, float y, float z)
{
    return (plane.x * x + plane.y * y + plane.z * z + plane.w);
}

// the frustum shaboing boing

RLFrustum* CreateFrustum(void)
{
    RLFrustum* frustum = (RLFrustum*)malloc(sizeof(RLFrustum));
    if (frustum != NULL)
    {
        for (int i = 0; i < FRUSTUM_PLANE_COUNT; i++)
        {
            frustum->planes[i] = (Vector4){ 0.0f, 0.0f, 0.0f, 0.0f };
        }
    }
    return frustum;
}

void ExtractFrustum(RLFrustum* frustum)
{
    if (frustum == NULL) return;

    Matrix projection = rlGetMatrixProjection();
    Matrix modelview = rlGetMatrixModelview();

    Matrix planes = { 0 };

    planes.m0 = modelview.m0 * projection.m0 + modelview.m1 * projection.m4 + modelview.m2 * projection.m8 + modelview.m3 * projection.m12;
    planes.m1 = modelview.m0 * projection.m1 + modelview.m1 * projection.m5 + modelview.m2 * projection.m9 + modelview.m3 * projection.m13;
    planes.m2 = modelview.m0 * projection.m2 + modelview.m1 * projection.m6 + modelview.m2 * projection.m10 + modelview.m3 * projection.m14;
    planes.m3 = modelview.m0 * projection.m3 + modelview.m1 * projection.m7 + modelview.m2 * projection.m11 + modelview.m3 * projection.m15;
    
    planes.m4 = modelview.m4 * projection.m0 + modelview.m5 * projection.m4 + modelview.m6 * projection.m8 + modelview.m7 * projection.m12;
    planes.m5 = modelview.m4 * projection.m1 + modelview.m5 * projection.m5 + modelview.m6 * projection.m9 + modelview.m7 * projection.m13;
    planes.m6 = modelview.m4 * projection.m2 + modelview.m5 * projection.m6 + modelview.m6 * projection.m10 + modelview.m7 * projection.m14;
    planes.m7 = modelview.m4 * projection.m3 + modelview.m5 * projection.m7 + modelview.m6 * projection.m11 + modelview.m7 * projection.m15;
    
    planes.m8 = modelview.m8 * projection.m0 + modelview.m9 * projection.m4 + modelview.m10 * projection.m8 + modelview.m11 * projection.m12;
    planes.m9 = modelview.m8 * projection.m1 + modelview.m9 * projection.m5 + modelview.m10 * projection.m9 + modelview.m11 * projection.m13;
    planes.m10 = modelview.m8 * projection.m2 + modelview.m9 * projection.m6 + modelview.m10 * projection.m10 + modelview.m11 * projection.m14;
    planes.m11 = modelview.m8 * projection.m3 + modelview.m9 * projection.m7 + modelview.m10 * projection.m11 + modelview.m11 * projection.m15;
    
    planes.m12 = modelview.m12 * projection.m0 + modelview.m13 * projection.m4 + modelview.m14 * projection.m8 + modelview.m15 * projection.m12;
    planes.m13 = modelview.m12 * projection.m1 + modelview.m13 * projection.m5 + modelview.m14 * projection.m9 + modelview.m15 * projection.m13;
    planes.m14 = modelview.m12 * projection.m2 + modelview.m13 * projection.m6 + modelview.m14 * projection.m10 + modelview.m15 * projection.m14;
    planes.m15 = modelview.m12 * projection.m3 + modelview.m13 * projection.m7 + modelview.m14 * projection.m11 + modelview.m15 * projection.m15;

    frustum->planes[FRUSTUM_RIGHT] = (Vector4){ planes.m3 - planes.m0, planes.m7 - planes.m4, planes.m11 - planes.m8, planes.m15 - planes.m12 };
    NormalizePlane(&frustum->planes[FRUSTUM_RIGHT]);

    frustum->planes[FRUSTUM_LEFT] = (Vector4){ planes.m3 + planes.m0, planes.m7 + planes.m4, planes.m11 + planes.m8, planes.m15 + planes.m12 };
    NormalizePlane(&frustum->planes[FRUSTUM_LEFT]);

    frustum->planes[FRUSTUM_TOP] = (Vector4){ planes.m3 - planes.m1, planes.m7 - planes.m5, planes.m11 - planes.m9, planes.m15 - planes.m13 };
    NormalizePlane(&frustum->planes[FRUSTUM_TOP]);

    frustum->planes[FRUSTUM_BOTTOM] = (Vector4){ planes.m3 + planes.m1, planes.m7 + planes.m5, planes.m11 + planes.m9, planes.m15 + planes.m13 };
    NormalizePlane(&frustum->planes[FRUSTUM_BOTTOM]);

    frustum->planes[FRUSTUM_BACK] = (Vector4){ planes.m3 - planes.m2, planes.m7 - planes.m6, planes.m11 - planes.m10, planes.m15 - planes.m14 };
    NormalizePlane(&frustum->planes[FRUSTUM_BACK]);

    frustum->planes[FRUSTUM_FRONT] = (Vector4){ planes.m3 + planes.m2, planes.m7 + planes.m6, planes.m11 + planes.m10, planes.m15 + planes.m14 };
    NormalizePlane(&frustum->planes[FRUSTUM_FRONT]);
}

bool FrustumPointIn(const RLFrustum* frustum, Vector3 position)
{
    if (frustum == NULL) return false;

    for (int i = 0; i < FRUSTUM_PLANE_COUNT; i++)
    {
        if (DistanceToPlane(frustum->planes[i], position) <= 0) 
            return false;
    }

    return true;
}

bool FrustumPointInXYZ(const RLFrustum* frustum, float x, float y, float z)
{
    if (frustum == NULL) return false;

    for (int i = 0; i < FRUSTUM_PLANE_COUNT; i++)
    {
        if (DistanceToPlaneXYZ(frustum->planes[i], x, y, z) <= 0) 
            return false;
    }

    return true;
}

bool FrustumSphereIn(const RLFrustum* frustum, Vector3 position, float radius)
{
    if (frustum == NULL) return false;

    for (int i = 0; i < FRUSTUM_PLANE_COUNT; i++)
    {
        if (DistanceToPlane(frustum->planes[i], position) < -radius) 
            return false;
    }

    return true;
}

bool FrustumSphereInXYZ(const RLFrustum* frustum, float x, float y, float z, float radius)
{
    if (frustum == NULL) return false;

    for (int i = 0; i < FRUSTUM_PLANE_COUNT; i++)
    {
        if (DistanceToPlaneXYZ(frustum->planes[i], x, y, z) < -radius) 
            return false;
    }

    return true;
}

bool FrustumAABBoxIn(const RLFrustum* frustum, Vector3 min, Vector3 max)
{
    if (frustum == NULL) return false;

    // if any point is in, we are good
    if (FrustumPointInXYZ(frustum, min.x, min.y, min.z)) return true;
    if (FrustumPointInXYZ(frustum, min.x, max.y, min.z)) return true;
    if (FrustumPointInXYZ(frustum, max.x, max.y, min.z)) return true;
    if (FrustumPointInXYZ(frustum, max.x, min.y, min.z)) return true;
    if (FrustumPointInXYZ(frustum, min.x, min.y, max.z)) return true;
    if (FrustumPointInXYZ(frustum, min.x, max.y, max.z)) return true;
    if (FrustumPointInXYZ(frustum, max.x, max.y, max.z)) return true;
    if (FrustumPointInXYZ(frustum, max.x, min.y, max.z)) return true;

    // check to see if all points are outside of any plane, if so the entire box is outside
    for (int i = 0; i < FRUSTUM_PLANE_COUNT; i++)
    {
        bool oneInside = false;

        if (DistanceToPlaneXYZ(frustum->planes[i], min.x, min.y, min.z) >= 0) oneInside = true;
        if (DistanceToPlaneXYZ(frustum->planes[i], max.x, min.y, min.z) >= 0) oneInside = true;
        if (DistanceToPlaneXYZ(frustum->planes[i], max.x, max.y, min.z) >= 0) oneInside = true;
        if (DistanceToPlaneXYZ(frustum->planes[i], min.x, max.y, min.z) >= 0) oneInside = true;
        if (DistanceToPlaneXYZ(frustum->planes[i], min.x, min.y, max.z) >= 0) oneInside = true;
        if (DistanceToPlaneXYZ(frustum->planes[i], max.x, min.y, max.z) >= 0) oneInside = true;
        if (DistanceToPlaneXYZ(frustum->planes[i], max.x, max.y, max.z) >= 0) oneInside = true;
        if (DistanceToPlaneXYZ(frustum->planes[i], min.x, max.y, max.z) >= 0) oneInside = true;

        if (!oneInside)
            return false;
    }

    // the box extends outside the frustum but crosses it
    return true;
}