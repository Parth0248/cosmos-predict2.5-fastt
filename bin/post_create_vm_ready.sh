#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Post-create initialization for Brev launchable environments.
# Intended to run once after the VM is ready.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

echo "[post-create] Initializing Cosmos-Predict2.5 launchable environment..."

# Pull model and asset pointers tracked by git-lfs.
if command -v git-lfs >/dev/null 2>&1 || git lfs version >/dev/null 2>&1; then
    git lfs pull
fi

# Match the lightweight image2representation setup by default.
CUDA_NAME="${CUDA_NAME:-cu128}"
uv sync --locked --extra="${CUDA_NAME}"

# Validate only when a GPU is visible.
if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1; then
    python scripts/check_environment.py
else
    echo "[post-create] NVIDIA GPU not detected yet; skipping check_environment.py."
fi

echo "[post-create] Environment initialization complete."
