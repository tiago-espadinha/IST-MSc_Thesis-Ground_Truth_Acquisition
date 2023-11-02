'''
SETUP_ASSETS - This script sets up the necessary assets for the 231102_yolo project by copying files from a shared assets directory.

It creates an 'assets' directory in the current project folder and copies specified asset files from a shared directory.

Inputs:
    None

Outputs:
    Copies asset files to the project's assets directory.

Author: Tiago Simões
Project: VIENA
Instituto Superior Técnico
November 2023; Last revision: 16-July-2025
'''
#------------- BEGIN MAIN FUNCTION ---------------

import os
import shutil

# Get the root directory of the project
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
share_assets_dir = os.path.join(project_root, 'shared-assets')

# Create the assets directory within the current project folder
current_project_assets_dir = os.path.join(os.path.dirname(__file__), 'assets')
if not os.path.exists(current_project_assets_dir):
    os.makedirs(current_project_assets_dir)

# List of asset files to copy from share-assets
asset_files = ['Viena_30s.mp4', '1o_teste_velocidade_baixa.MOV']

# Copy the asset files
for file in asset_files:
    src_path = os.path.join(share_assets_dir, file)
    dest_path = os.path.join(current_project_assets_dir, file)
    if os.path.exists(src_path):
        shutil.copy(src_path, dest_path)
        print(f'Copied {file} to {current_project_assets_dir}')
    else:
        print(f'Warning: {file} not found in {share_assets_dir}')

print('Assets setup complete for 231102_yolo!')

#------------- END OF MAIN FUNCTION --------------