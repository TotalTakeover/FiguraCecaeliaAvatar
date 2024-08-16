local Config = {
  --Should the model get textures from the player's skin.
  usesPlayerSkin = true,
  --Should the model use Slim proportions, or Steve proportions.
  isSlim = true,
  --How should the Whirl Pool be handled?
  --Set to `true` to have it enabled by default.
  --Set to `false` to have it disabled by default.
  --Set to `nil` to allow the Dolphins Grace Status Effect to control it. This will also prevent an ActionWheel action from being created.
  whirlPoolEffect = false,
  --Should the tail have glowing parts.
  emissive = false,
  --Should the glowing of the tail change based on Light Levels?
  lightLevel = false,
  --What is your keybind for spraying ink?
  inkKeybind = "v",
  --What color should your ink be? (Will change when glowing.)
  inkRGB = vec(0/255, 0/255, 0/255),
  --How should the glowing eyes be handled?
  --Set to `true` to have them enabled by default.
  --Set to `false` to have them disabled by default.
  --Set to `nil` to allow the merling origin to control them. This will also prevent an ActionWheel action from being created.
  glowingEyes = false,
  --Should the tail make noise when you land after falling/jumping?
  flopSound = false,
  --Should your tentacles hold items rather than your hands?
  tentacleHeldItems = false,
  --Should your arms have move while swimming?
  armMovement = true,
  --Should your Camera match your head's position? (NOTICE: Crosshair will be off by ~2 Block Pixels)
  matchCamera = false,
}
return Config
