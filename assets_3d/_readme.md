# VRML 3D Assets

## Description

This folder contains 3D models and assets used to create the Virtual Reality Modeling Language (VRML) worlds for simulations within the VIENA project. It includes source files from Blender and AutoCAD, as well as the final `.wrl` files and their texture assets.

## Usage

The `.wrl` files in this directory are used by various MATLAB simulations in the project that require the MATLAB Virtual Reality Toolbox. The scenes typically define a vehicle (`viena_capture.wrl`) within an environment (`viena_scene_capture.wrl`).

## Contents

-   **`viena_scene_capture.wrl`**: Main VRML world for simulations. It includes the `viena_capture.wrl` vehicle model, a textured background, and predefined camera viewpoints.
-   **`viena_scene_render.wrl`**: A VRML scene for rendering purposes, using `viena_render.wrl`.
-   **`viena_capture.wrl`**: VRML model of the VIENA vehicle, used for simulation and frame capture.
-   **`viena_render.wrl`**: VRML model of the VIENA vehicle, optimized for rendering.
-   **`vrml_background.wrl`**: Defines the background and floor for the scenes.
-   **`vrml_cube.wrl`**: A simple VRML scene with a cube, likely for testing or calibration purposes.

### Source Files
-   **`viena_capture.blend`**: Source file for the `viena_capture.wrl` model from Blender.
-   **`viena_capture.fbx`**: Vehicle model in FBX format.
-   **`viena_render.dwg`**: Source AutoCAD drawing for the `viena_render.wrl` model.
-   **`parking_lot_final.ply`**: 3D model of a parking lot in PLY format.

### Textures
-   **`background.jpg`**, **`texture*.jpg`**, **`viena_texture.jpg`**: Image files used as textures in the VRML worlds.
