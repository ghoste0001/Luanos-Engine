/**********************************************************************************************
*
* raylibExtras * Utilities and Shared Components for Raylib
*
* RLAssets * Simple Asset Managment System for Raylib
*
* LICENSE: MIT
*
* Copyright (c) 2020 Jeffery Myers
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
**********************************************************************************************/

#include "raylib.h"
#include <stdbool.h>

typedef enum {
    FRUSTUM_RIGHT = 0,
    FRUSTUM_LEFT,
    FRUSTUM_TOP,
    FRUSTUM_BOTTOM,
    FRUSTUM_FRONT,
    FRUSTUM_BACK,
    FRUSTUM_PLANE_COUNT
} FrustumPlanes;

typedef struct RLFrustum {
    Vector4 planes[FRUSTUM_PLANE_COUNT];
} RLFrustum;

RLFrustum* CreateFrustum(void);
void ExtractFrustum(RLFrustum* frustum);

bool FrustumPointIn(const RLFrustum* frustum, Vector3 position);
bool FrustumPointInXYZ(const RLFrustum* frustum, float x, float y, float z);
bool FrustumSphereIn(const RLFrustum* frustum, Vector3 position, float radius);
bool FrustumSphereInXYZ(const RLFrustum* frustum, float x, float y, float z, float radius);
bool FrustumAABBoxIn(const RLFrustum* frustum, Vector3 min, Vector3 max);