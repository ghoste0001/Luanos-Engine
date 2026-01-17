# Luanos Engine
<img src="repo/LuanosEngineCard.png"/>
<a href="https://discord.gg/xMPCsx3dNf" style="text-decoration:none;">
    <img src="https://img.shields.io/badge/Discord-5865F2?logo=discord&logoColor=white&style=for-the-badge" alt="Discord"/>
</a>

# Dependencies
1. [Zune](https://github.com/Scythe-Technology/zune)
2. [Raylib](https://github.com/raysan5/raylib)
3. [raylib-gizmo](https://github.com/cloudofoz/raylib-gizmo)
4. [ImGui](https://github.com/ocornut/imgui)
5. [rlImGui](https://github.com/raylib-extras/rlImGui)
6. [ImGuiColorTextEdit](https://github.com/BalazsJako/ImGuiColorTextEdit)

# Running Luanos Engine
### Linux
1. Install Zune
<br>Follow its installation instructions at https://github.com/Scythe-Technology/zune

2. Clone the Repository
```bash
git clone https://github.com/Zalthen-dev/Luanos-Engine.git --depth 1
cd Luanos-Engine
```

3. Navigate to `vendor` folder and clone dependencies
```bash
cd vendor

git clone https://github.com/raysan5/raylib.git
git clone https://github.com/cloudofoz/raylib-gizmo.git
git clone https://github.com/ocornut/imgui.git --branch docking
git clone https://github.com/raylib-extras/rlImGui.git
git clone https://github.com/BalazsJako/ImGuiColorTextEdit.git
```

4. Build the engine library
```bash
cmake --build .
```
5. Navigate back to engine folder and run the engine
```bash
cd ..
zune run engine
```
---
### Windows
Todo

# How to Use
As of right now, Lunaos Engine only runs one script when it starts up, that at `src/test.luau` which will change soon!
<br>You can edit this script to do what you want!

# How to Help
You can help out by using Luanos Engine and reporting any bugs you find!
<br> You can also request features to be added! Here or in the discord server!

If you know how to code, help out by creating pull requests to add and change code!