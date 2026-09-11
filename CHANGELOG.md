# 2.15.2

- Preserve the improved AI attack target cycle, wall-defense counts and ladder
  destinations in saved games and replay starting worlds. Previously these
  values remained in process memory, so loading a world could change later AI
  decisions even when all RNG values had been restored.
- Initialize this state when loading maps or older saves that do not contain it.
  The missing state of an old save cannot be reconstructed exactly.
- Require map-extensions 1.0.0 and UCP 3.0.7 for the existing custom save-section
  mechanism. Save and restore happen at world boundaries, with no new tick hooks.
- Expose the same serializer as a read-only export for multiplayer world captures,
  where invoking the native save routine is unsuitable.
