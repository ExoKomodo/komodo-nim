# 
#   rlgl v3.1 - raylib OpenGL abstraction layer
# 
#   rlgl is a wrapper for multiple OpenGL versions (1.1, 2.1, 3.3 Core, ES 2.0) to
#   pseudo-OpenGL 1.1 style functions (rlVertex, rlTranslate, rlRotate...).
# 
#   When chosing an OpenGL version greater than OpenGL 1.1, rlgl stores vertex data on internal
#   VBO buffers (and VAOs if available). It requires calling 3 functions:
#       rlglInit()  - Initialize internal buffers and auxiliar resources
#       rlglDraw()  - Process internal buffers and send required draw calls
#       rlglClose() - De-initialize internal buffers data and other auxiliar resources
# 
#   CONFIGURATION:
# 
#   #define GRAPHICS_API_OPENGL_11
#   #define GRAPHICS_API_OPENGL_21
#   #define GRAPHICS_API_OPENGL_33
#   #define GRAPHICS_API_OPENGL_ES2
#       Use selected OpenGL graphics backend, should be supported by platform
#       Those preprocessor defines are only used on rlgl module, if OpenGL version is
#       required by any other module, use rlGetVersion() tocheck it
# 
#   #define RLGL_IMPLEMENTATION
#       Generates the implementation of the library into the included file.
#       If not defined, the library is in header only mode and can be included in other headers
#       or source files without problems. But only ONE file should hold the implementation.
# 
#   #define RLGL_STANDALONE
#       Use rlgl as standalone library (no raylib dependency)
# 
#   #define SUPPORT_VR_SIMULATOR
#       Support VR simulation functionality (stereo rendering)
# 
#   DEPENDENCIES:
#       raymath     - 3D math functionality (Vector3, Matrix, Quaternion)
#       GLAD        - OpenGL extensions loading (OpenGL 3.3 Core only)
# 
# 
#   LICENSE: zlib/libpng
# 
#   Copyright (c) 2014-2021 Ramon Santamaria (@raysan5)
# 
#   This software is provided "as-is", without any express or implied warranty. In no event
#   will the authors be held liable for any damages arising from the use of this software.
# 
#   Permission is granted to anyone to use this software for any purpose, including commercial
#   applications, and to alter it and redistribute it freely, subject to the following restrictions:
# 
#     1. The origin of this software must not be misrepresented; you must not claim that you
#     wrote the original software. If you use this software in a product, an acknowledgment
#     in the product documentation would be appreciated but is not required.
# 
#     2. Altered source versions must be plainly marked as such, and must not be misrepresented
#     as being the original software.
# 
#     3. This notice may not be removed or altered from any source distribution.
#
template RLGL_H*(): auto = RLGL_H
{.pragma: RLAPI, cdecl, discardable, dynlib: "libraylib" & LEXT.}
import raylib
# Security check in case no GRAPHICS_API_OPENGL_* defined
# Security check in case multiple GRAPHICS_API_OPENGL_* defined
template SUPPORT_RENDER_TEXTURES_HINT*(): auto = SUPPORT_RENDER_TEXTURES_HINT
# ----------------------------------------------------------------------------------
# Defines and Macros
# ----------------------------------------------------------------------------------
# Default internal render batch limits
# Internal Matrix stack
# Shader and material limits
# Projection matrix culling
# Texture parameters (equivalent to OpenGL defines)
template RL_TEXTURE_WRAP_S*(): auto = 0x2802
template RL_TEXTURE_WRAP_T*(): auto = 0x2803
template RL_TEXTURE_MAG_FILTER*(): auto = 0x2800
template RL_TEXTURE_MIN_FILTER*(): auto = 0x2801
template RL_TEXTURE_ANISOTROPIC_FILTER*(): auto = 0x3000
template RL_FILTER_NEAREST*(): auto = 0x2600
template RL_FILTER_LINEAR*(): auto = 0x2601
template RL_FILTER_MIP_NEAREST*(): auto = 0x2700
template RL_FILTER_NEAREST_MIP_LINEAR*(): auto = 0x2702
template RL_FILTER_LINEAR_MIP_NEAREST*(): auto = 0x2701
template RL_FILTER_MIP_LINEAR*(): auto = 0x2703
template RL_WRAP_REPEAT*(): auto = 0x2901
template RL_WRAP_CLAMP*(): auto = 0x812F
template RL_WRAP_MIRROR_REPEAT*(): auto = 0x8370
template RL_WRAP_MIRROR_CLAMP*(): auto = 0x8742
# Matrix modes (equivalent to OpenGL)
template RL_MODELVIEW*(): auto = 0x1700
template RL_PROJECTION*(): auto = 0x1701
template RL_TEXTURE*(): auto = 0x1702
# Primitive assembly draw modes
template RL_LINES*(): auto = 0x0001
template RL_TRIANGLES*(): auto = 0x0004
template RL_QUADS*(): auto = 0x0007
# ----------------------------------------------------------------------------------
# Types and Structures Definition
# ----------------------------------------------------------------------------------
type FramebufferAttachType* = enum
  RL_ATTACHMENT_COLOR_CHANNEL0 = 0
  RL_ATTACHMENT_COLOR_CHANNEL1
  RL_ATTACHMENT_COLOR_CHANNEL2
  RL_ATTACHMENT_COLOR_CHANNEL3
  RL_ATTACHMENT_COLOR_CHANNEL4
  RL_ATTACHMENT_COLOR_CHANNEL5
  RL_ATTACHMENT_COLOR_CHANNEL6
  RL_ATTACHMENT_COLOR_CHANNEL7
  RL_ATTACHMENT_DEPTH = 100
  RL_ATTACHMENT_STENCIL = 200
converter FramebufferAttachType2int32*(self: FramebufferAttachType): int32 = self.int32
type FramebufferTexType* = enum
  RL_ATTACHMENT_CUBEMAP_POSITIVE_X = 0
  RL_ATTACHMENT_CUBEMAP_NEGATIVE_X
  RL_ATTACHMENT_CUBEMAP_POSITIVE_Y
  RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y
  RL_ATTACHMENT_CUBEMAP_POSITIVE_Z
  RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z
  RL_ATTACHMENT_TEXTURE2D = 100
  RL_ATTACHMENT_RENDERBUFFER = 200
converter FramebufferTexType2int32*(self: FramebufferTexType): int32 = self.int32
# ------------------------------------------------------------------------------------
# Functions Declaration - Matrix operations
# ------------------------------------------------------------------------------------
func rlMatrixMode*(mode: int32) {.RLAPI,
    importc: "rlMatrixMode".} # Choose the current matrix to be transformed
func rlPushMatrix*() {.RLAPI, importc: "rlPushMatrix".} # Push the current matrix to stack
func rlPopMatrix*() {.RLAPI, importc: "rlPopMatrix".} # Pop lattest inserted matrix from stack
func rlLoadIdentity*() {.RLAPI, importc: "rlLoadIdentity".} # Reset current matrix to identity matrix
func rlTranslatef*(x: float32; y: float32; z: float32) {.RLAPI,
    importc: "rlTranslatef".} # Multiply the current matrix by a translation matrix
func rlRotatef*(angleDeg: float32; x: float32; y: float32; z: float32) {.RLAPI,
    importc: "rlRotatef".} # Multiply the current matrix by a rotation matrix
func rlScalef*(x: float32; y: float32; z: float32) {.RLAPI,
    importc: "rlScalef".} # Multiply the current matrix by a scaling matrix
func rlMultMatrixf*(matf: float32) {.RLAPI,
    importc: "rlMultMatrixf".} # Multiply the current matrix by another matrix
func rlFrustum*(left: float64; right: float64; bottom: float64; top: float64;
    znear: float64; zfar: float64) {.RLAPI, importc: "rlFrustum".}
func rlOrtho*(left: float64; right: float64; bottom: float64; top: float64;
    znear: float64; zfar: float64) {.RLAPI, importc: "rlOrtho".}
func rlViewport*(x: int32; y: int32; width: int32; height: int32) {.RLAPI,
    importc: "rlViewport".} # Set the viewport area
# ------------------------------------------------------------------------------------
# Functions Declaration - Vertex level operations
# ------------------------------------------------------------------------------------
func rlBegin*(mode: int32) {.RLAPI, importc: "rlBegin".} # Initialize drawing mode (how to organize vertex)
func rlEnd*() {.RLAPI, importc: "rlEnd".} # Finish vertex providing
func rlVertex2i*(x: int32; y: int32) {.RLAPI,
    importc: "rlVertex2i".} # Define one vertex (position) - 2 int
func rlVertex2f*(x: float32; y: float32) {.RLAPI,
    importc: "rlVertex2f".} # Define one vertex (position) - 2 float
func rlVertex3f*(x: float32; y: float32; z: float32) {.RLAPI,
    importc: "rlVertex3f".} # Define one vertex (position) - 3 float
func rlTexCoord2f*(x: float32; y: float32) {.RLAPI,
    importc: "rlTexCoord2f".} # Define one vertex (texture coordinate) - 2 float
func rlNormal3f*(x: float32; y: float32; z: float32) {.RLAPI,
    importc: "rlNormal3f".} # Define one vertex (normal) - 3 float
func rlColor4ub*(r: uint8; g: uint8; b: uint8; a: uint8) {.RLAPI,
    importc: "rlColor4ub".} # Define one vertex (color) - 4 byte
func rlColor3f*(x: float32; y: float32; z: float32) {.RLAPI,
    importc: "rlColor3f".} # Define one vertex (color) - 3 float
func rlColor4f*(x: float32; y: float32; z: float32; w: float32) {.RLAPI,
    importc: "rlColor4f".} # Define one vertex (color) - 4 float
# ------------------------------------------------------------------------------------
# Functions Declaration - OpenGL equivalent functions (common to 1.1, 3.3+, ES2)
# NOTE: This functions are used to completely abstract raylib code from OpenGL layer
# ------------------------------------------------------------------------------------
func rlEnableTexture*(id: uint32) {.RLAPI, importc: "rlEnableTexture".} # Enable texture usage
func rlDisableTexture*() {.RLAPI, importc: "rlDisableTexture".} # Disable texture usage
func rlTextureParameters*(id: uint32; param: int32; value: int32) {.RLAPI,
    importc: "rlTextureParameters".} # Set texture parameters (filter, wrap)
func rlEnableShader*(id: uint32) {.RLAPI,
    importc: "rlEnableShader".} # Enable shader program usage
func rlDisableShader*() {.RLAPI, importc: "rlDisableShader".} # Disable shader program usage
func rlEnableFramebuffer*(id: uint32) {.RLAPI,
    importc: "rlEnableFramebuffer".} # Enable render texture (fbo)
func rlDisableFramebuffer*() {.RLAPI, importc: "rlDisableFramebuffer".} # Disable render texture (fbo), return to default framebuffer
func rlEnableDepthTest*() {.RLAPI, importc: "rlEnableDepthTest".} # Enable depth test
func rlDisableDepthTest*() {.RLAPI, importc: "rlDisableDepthTest".} # Disable depth test
func rlEnableDepthMask*() {.RLAPI, importc: "rlEnableDepthMask".} # Enable depth write
func rlDisableDepthMask*() {.RLAPI, importc: "rlDisableDepthMask".} # Disable depth write
func rlEnableBackfaceCulling*() {.RLAPI,
    importc: "rlEnableBackfaceCulling".} # Enable backface culling
func rlDisableBackfaceCulling*() {.RLAPI,
    importc: "rlDisableBackfaceCulling".} # Disable backface culling
func rlEnableScissorTest*() {.RLAPI, importc: "rlEnableScissorTest".} # Enable scissor test
func rlDisableScissorTest*() {.RLAPI, importc: "rlDisableScissorTest".} # Disable scissor test
func rlScissor*(x: int32; y: int32; width: int32; height: int32) {.RLAPI,
    importc: "rlScissor".} # Scissor test
func rlEnableWireMode*() {.RLAPI, importc: "rlEnableWireMode".} # Enable wire mode
func rlDisableWireMode*() {.RLAPI, importc: "rlDisableWireMode".} # Disable wire mode
func rlSetLineWidth*(width: float32) {.RLAPI,
    importc: "rlSetLineWidth".} # Set the line drawing width
func rlGetLineWidth*(): float32 {.RLAPI,
    importc: "rlGetLineWidth".} # Get the line drawing width
func rlEnableSmoothLines*() {.RLAPI, importc: "rlEnableSmoothLines".} # Enable line aliasing
func rlDisableSmoothLines*() {.RLAPI, importc: "rlDisableSmoothLines".} # Disable line aliasing
func rlClearColor*(r: uint8; g: uint8; b: uint8; a: uint8) {.RLAPI,
    importc: "rlClearColor".} # Clear color buffer with color
func rlClearScreenBuffers*() {.RLAPI, importc: "rlClearScreenBuffers".} # Clear used screen buffers (color and depth)
func rlUpdateBuffer*(bufferId: int32; data: pointer; dataSize: int32) {.RLAPI,
    importc: "rlUpdateBuffer".} # Update GPU buffer with new data
func rlLoadAttribBuffer*(vaoId: uint32; shaderLoc: int32; buffer: pointer;
    size: int32; dynamic: bool): uint32 {.RLAPI,
    importc: "rlLoadAttribBuffer".} # Load a new attributes buffer
# ------------------------------------------------------------------------------------
# Functions Declaration - rlgl functionality
# ------------------------------------------------------------------------------------
func rlglInit*(width: int32; height: int32) {.RLAPI,
    importc: "rlglInit".} # Initialize rlgl (buffers, shaders, textures, states)
func rlglClose*() {.RLAPI, importc: "rlglClose".} # De-inititialize rlgl (buffers, shaders, textures)
func rlglDraw*() {.RLAPI, importc: "rlglDraw".} # Update and draw default internal buffers
func rlCheckErrors*() {.RLAPI, importc: "rlCheckErrors".} # Check and log OpenGL error codes
func rlGetVersion*(): int32 {.RLAPI, importc: "rlGetVersion".} # Returns current OpenGL version
func rlCheckBufferLimit*(vCount: int32): bool {.RLAPI,
    importc: "rlCheckBufferLimit".} # Check internal buffer overflow for a given number of vertex
func rlSetDebugMarker*(text: cstring) {.RLAPI,
    importc: "rlSetDebugMarker".} # Set debug marker for analysis
func rlSetBlendMode*(glSrcFactor: int32; glDstFactor: int32;
    glEquation: int32) {.RLAPI, importc: "rlSetBlendMode".} #
func rlLoadExtensions*(loader: pointer) {.RLAPI,
    importc: "rlLoadExtensions".} # Load OpenGL extensions
# Textures data management
func rlLoadTexture*(data: pointer; width: int32; height: int32; format: int32;
    mipmapCount: int32): uint32 {.RLAPI, importc: "rlLoadTexture".} # Load texture in GPU
func rlLoadTextureDepth*(width: int32; height: int32;
    useRenderBuffer: bool): uint32 {.RLAPI,
    importc: "rlLoadTextureDepth".} # Load depth texture/renderbuffer (to be attached to fbo)
func rlLoadTextureCubemap*(data: pointer; size: int32; format: int32): uint32 {.
    RLAPI, importc: "rlLoadTextureCubemap".} # Load texture cubemap
func rlUpdateTexture*(id: uint32; offsetX: int32; offsetY: int32; width: int32;
    height: int32; format: int32; data: pointer) {.RLAPI,
    importc: "rlUpdateTexture".} # Update GPU texture with new data
func rlGetGlTextureFormats*(format: int32; glInternalFormat: uint32;
    glFormat: uint32; glType: uint32) {.RLAPI,
    importc: "rlGetGlTextureFormats".} # Get OpenGL internal formats
func rlUnloadTexture*(id: uint32) {.RLAPI,
    importc: "rlUnloadTexture".} # Unload texture from GPU memory
func rlGenerateMipmaps*(texture: ptr Texture2D) {.RLAPI,
    importc: "rlGenerateMipmaps".} # Generate mipmap data for selected texture
func rlReadTexturePixels*(texture: Texture2D): pointer {.RLAPI,
    importc: "rlReadTexturePixels".} # Read texture pixel data
func rlReadScreenPixels*(width: int32; height: int32): uint8 {.RLAPI,
    importc: "rlReadScreenPixels".} # Read screen pixel data (color buffer)
# Framebuffer management (fbo)
func rlLoadFramebuffer*(width: int32; height: int32): uint32 {.RLAPI,
    importc: "rlLoadFramebuffer".} # Load an empty framebuffer
func rlFramebufferAttach*(fboId: uint32; texId: uint32; attachType: int32;
    texType: int32) {.RLAPI,
    importc: "rlFramebufferAttach".} # Attach texture/renderbuffer to a framebuffer
func rlFramebufferComplete*(id: uint32): bool {.RLAPI,
    importc: "rlFramebufferComplete".} # Verify framebuffer is complete
func rlUnloadFramebuffer*(id: uint32) {.RLAPI,
    importc: "rlUnloadFramebuffer".} # Delete framebuffer from GPU
# Vertex data management
func rlLoadMesh*(mesh: ptr Mesh; dynamic: bool) {.RLAPI,
    importc: "rlLoadMesh".} # Upload vertex data into GPU and provided VAO/VBO ids
func rlUpdateMesh*(mesh: Mesh; buffer: int32; count: int32) {.RLAPI,
    importc: "rlUpdateMesh".} # Update vertex or index data on GPU (upload new data to one buffer)
func rlUpdateMeshAt*(mesh: Mesh; buffer: int32; count: int32; index: int32) {.
    RLAPI, importc: "rlUpdateMeshAt".} # Update vertex or index data on GPU, at index
func rlDrawMesh*(mesh: Mesh; material: Material; transform: Matrix) {.RLAPI,
    importc: "rlDrawMesh".} # Draw a 3d mesh with material and transform
func rlDrawMeshInstanced*(mesh: Mesh; material: Material;
    transforms: ptr Matrix; count: int32) {.RLAPI,
    importc: "rlDrawMeshInstanced".} # Draw a 3d mesh with material and transform
func rlUnloadMesh*(mesh: Mesh) {.RLAPI, importc: "rlUnloadMesh".} # Unload mesh data from CPU and GPU
# NOTE: There is a set of shader related functions that are available to end user,
# to avoid creating function wrappers through core module, they have been directly declared in raylib.h
# ------------------------------------------------------------------------------------
# Shaders System Functions (Module: rlgl)
# NOTE: This functions are useless when using OpenGL 1.1
# ------------------------------------------------------------------------------------
# Shader loading/unloading functions
func LoadShader*(vsFileName: cstring; fsFileName: cstring): Shader {.RLAPI,
    importc: "LoadShader".} # Load shader from files and bind default locations
func LoadShaderCode*(vsCode: cstring; fsCode: cstring): Shader {.RLAPI,
    importc: "LoadShaderCode".} # Load shader from code strings and bind default locations
func UnloadShader*(shader: Shader) {.RLAPI,
    importc: "UnloadShader".} # Unload shader from GPU memory (VRAM)
func GetShaderDefault*(): Shader {.RLAPI, importc: "GetShaderDefault".} # Get default shader
func GetTextureDefault*(): Texture2D {.RLAPI,
    importc: "GetTextureDefault".} # Get default texture
func GetShapesTexture*(): Texture2D {.RLAPI,
    importc: "GetShapesTexture".} # Get texture to draw shapes
func GetShapesTextureRec*(): Rectangle {.RLAPI,
    importc: "GetShapesTextureRec".} # Get texture rectangle to draw shapes
# Shader configuration functions
func GetShaderLocation*(shader: Shader; uniformName: cstring): int32 {.RLAPI,
    importc: "GetShaderLocation".} # Get shader uniform location
func GetShaderLocationAttrib*(shader: Shader; attribName: cstring): int32 {.
    RLAPI, importc: "GetShaderLocationAttrib".} # Get shader attribute location
func SetShaderValue*(shader: Shader; uniformLoc: int32; value: pointer;
    uniformType: int32) {.RLAPI, importc: "SetShaderValue".} # Set shader uniform value
func SetShaderValueV*(shader: Shader; uniformLoc: int32; value: pointer;
    uniformType: int32; count: int32) {.RLAPI,
    importc: "SetShaderValueV".} # Set shader uniform value vector
func SetShaderValueMatrix*(shader: Shader; uniformLoc: int32; mat: Matrix) {.
    RLAPI, importc: "SetShaderValueMatrix".} # Set shader uniform value (matrix 4x4)
func SetMatrixProjection*(proj: Matrix) {.RLAPI,
    importc: "SetMatrixProjection".} # Set a custom projection matrix (replaces internal projection matrix)
func SetMatrixModelview*(view: Matrix) {.RLAPI,
    importc: "SetMatrixModelview".} # Set a custom modelview matrix (replaces internal modelview matrix)
func GetMatrixModelview*(): Matrix {.RLAPI,
    importc: "GetMatrixModelview".} # Get internal modelview matrix
# Texture maps generation (PBR)
# NOTE: Required shaders should be provided
func GenTextureCubemap*(shader: Shader; panorama: Texture2D; size: int32;
    format: int32): TextureCubemap {.RLAPI,
    importc: "GenTextureCubemap".} # Generate cubemap texture from 2D panorama texture
func GenTextureIrradiance*(shader: Shader; cubemap: TextureCubemap;
    size: int32): TextureCubemap {.RLAPI,
    importc: "GenTextureIrradiance".} # Generate irradiance texture using cubemap data
func GenTexturePrefilter*(shader: Shader; cubemap: TextureCubemap;
    size: int32): TextureCubemap {.RLAPI,
    importc: "GenTexturePrefilter".} # Generate prefilter texture using cubemap data
func GenTextureBRDF*(shader: Shader; size: int32): Texture2D {.RLAPI,
    importc: "GenTextureBRDF".} # Generate BRDF texture using cubemap data
# Shading begin/end functions
func BeginShaderMode*(shader: Shader) {.RLAPI,
    importc: "BeginShaderMode".} # Begin custom shader drawing
func EndShaderMode*() {.RLAPI, importc: "EndShaderMode".} # End custom shader drawing (use default shader)
func BeginBlendMode*(mode: int32) {.RLAPI,
    importc: "BeginBlendMode".} # Begin blending mode (alpha, additive, multiplied)
func EndBlendMode*() {.RLAPI, importc: "EndBlendMode".} # End blending mode (reset to default: alpha blending)
# VR control functions
func InitVrSimulator*() {.RLAPI, importc: "InitVrSimulator".} # Init VR simulator for selected device parameters
func CloseVrSimulator*() {.RLAPI, importc: "CloseVrSimulator".} # Close VR simulator for current device
func UpdateVrTracking*(camera: ptr Camera) {.RLAPI,
    importc: "UpdateVrTracking".} # Update VR tracking (position and orientation) and camera
func SetVrConfiguration*(info: VrDeviceInfo; distortion: Shader) {.RLAPI,
    importc: "SetVrConfiguration".} # Set stereo rendering configuration parameters
func IsVrSimulatorReady*(): bool {.RLAPI,
    importc: "IsVrSimulatorReady".} # Detect if VR simulator is ready
func ToggleVrMode*() {.RLAPI, importc: "ToggleVrMode".} # Enable/Disable VR experience
func BeginVrDrawing*() {.RLAPI, importc: "BeginVrDrawing".} # Begin VR simulator stereo rendering
func EndVrDrawing*() {.RLAPI, importc: "EndVrDrawing".} # End VR simulator stereo rendering
func LoadFileText*(fileName: cstring): ptr char {.RLAPI,
    importc: "LoadFileText".} # Load chars array from text file
func GetPixelDataSize*(width: int32; height: int32; format: int32): int32 {.
    RLAPI, importc: "GetPixelDataSize".} # Get pixel data size in bytes (image or texture)
# 
#   RLGL IMPLEMENTATION
#
type VertexBuffer* {.bycopy.} = object
  elementsCount*: int32 # Number of elements in the buffer (QUADS)
  vCounter*: int32      # Vertex position counter to process (and draw) from full buffer
  tcCounter*: int32     # Vertex texcoord counter to process (and draw) from full buffer
  cCounter*: int32      # Vertex color counter to process (and draw) from full buffer
  vertices*: float32    # Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
  texcoords*: float32 # Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
  colors*: uint8        # Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
  indices*: uint32 # Vertex indices (in case vertex data comes indexed) (6 indices per quad)
                        # Draw call type
                   # NOTE: Only texture changes register a new draw, other state-change-related elements are not
                   # used at this moment (vaoId, shaderId, matrices), raylib just forces a batch draw call if any
                        # of those state-change happens (this is done in core module)
type DrawCall* {.bycopy.} = object
  mode*: int32        # Drawing mode: LINES, TRIANGLES, QUADS
  vertexCount*: int32 # Number of vertex of the draw
  vertexAlignment*: int32 # Number of vertex required for index alignment (LINES, TRIANGLES)
  textureId*: uint32 # Texture id to be used on the draw -> Use to create new draw call if changes
                      # RenderBatch type
type RenderBatch* {.bycopy.} = object
  buffersCount*: int32            # Number of vertex buffers (multi-buffering support)
  currentBuffer*: int32           # Current buffer tracking in case of multi-buffering
  vertexBuffer*: ptr VertexBuffer # Dynamic buffer(s) for vertex data
  draws*: ptr DrawCall            # Draw calls array, depends on textureId
  drawsCounter*: int32            # Draw calls counter
  currentDepth*: float32          # Current depth value for next draw
                                  # VR Stereo rendering configuration for simulator
type VrStereoConfig* {.bycopy.} = object
  distortionShader*: Shader # VR stereo rendering distortion shader
  eyesProjection*: array[0..1, Matrix] # VR stereo rendering eyes projection matrices
  eyesViewOffset*: array[0..1, Matrix] # VR stereo rendering eyes view offset matrices
  eyeViewportRight*: array[0..3, int32] # VR stereo rendering right eye viewport [x, y, w, h]
  eyeViewportLeft*: array[0..3, int32] # VR stereo rendering left eye viewport [x, y, w, h]
type rlglData* {.bycopy.} = object
  currentBatch*: ptr RenderBatch # Current render batch
  defaultBatch*: RenderBatch     # Default internal render batch
                               # ----------------------------------------------------------------------------------
                                 # Global Variables Definition
                               # ----------------------------------------------------------------------------------
