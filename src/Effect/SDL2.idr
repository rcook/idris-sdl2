module Effect.SDL2

import Effects
import public Graphics.SDL2

export
data Colour = MkCol Int Int Int Int

export
black : Colour
black = MkCol 0 0 0 255

export
white : Colour
white = MkCol 255 255 255 255

export
red : Colour
red = MkCol 255 0 0 255

export
green : Colour
green = MkCol 0 255 0 255

export
blue : Colour
blue = MkCol 0 0 255 255

export
yellow : Colour
yellow = MkCol 255 255 0 255

export
cyan : Colour
cyan = MkCol 0 255 255 255

export
magenta : Colour
magenta = MkCol 255 0 255 255

Rdr : Type
Rdr = Renderer

export
data Sdl : Effect where
  Initialise : Int -> Int -> Sdl () () (\v => Rdr)
  Quit : Sdl () Rdr (\v => ())
  Flip : Sdl () Rdr (\v => Rdr)
  Poll : Sdl (Maybe Event) a (\v => a)
  WithRenderer : (Rdr -> IO a) -> Sdl a Rdr (\v => Rdr)

Handler Sdl IO where
  handle () (Initialise x y) k = do srf <- SDL2.init x y; k () srf
  handle s Quit k = do SDL2.quit; k () ()
  handle r Flip k = do renderPresent r; k () r
  handle r Poll k = do x <- pollEvent; k x r
  handle r (WithRenderer f) k = do res <- f r; k res r

public export
SDL2 : Type -> EFFECT
SDL2 res = MkEff res Sdl

public export
SDL2_ON : EFFECT
SDL2_ON = SDL2 SDL2.Renderer

export
initialise : Int -> Int -> { [SDL2 ()] ==> [SDL2_ON] } Eff ()
initialise x y = call $ Initialise x y

export
quit : { [SDL2_ON] ==> [SDL2 ()] } Eff ()
quit = call Quit

export
flip : { [SDL2_ON] } Eff ()
flip = call Flip

export
poll : { [SDL2_ON] } Eff (Maybe Event)
poll = call Poll

export
getRenderer : { [SDL2_ON] } Eff SDL2.Renderer
getRenderer = call $ WithRenderer (\s => pure s)

export
rectangle : Colour -> Int -> Int -> Int -> Int -> { [SDL2_ON] } Eff ()
rectangle (MkCol r g b a) x y w h
     = call $ WithRenderer (\s => filledRect s x y w h r g b a)

export
ellipse : Colour -> Int -> Int -> Int -> Int -> { [SDL2_ON] } Eff ()
ellipse (MkCol r g b a) x y rx ry
     = call $ WithRenderer (\s => filledEllipse s x y rx ry r g b a)

export
line : Colour -> Int -> Int -> Int -> Int -> { [SDL2_ON] } Eff ()
line (MkCol r g b a) x y ex ey
     = call $ WithRenderer (\s => drawLine s x y ex ey r g b a)
