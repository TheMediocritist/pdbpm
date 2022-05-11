# pdbpm
A [Playdate](play.date) library for syncing events to the BPM of an audio
track. Almost entirely the work of rxi, from here: https://github.com/rxi/lovebpm


## Installation
The [pdbpm.lua](pdbpm.lua?raw=1) file should be dropped into an existing
project and required by it:

```lua
pdbpm = import "pdbpm"
```

## Getting Started
First a `Track` object should be created using the `pdbpm.newTrack()`
function:

```lua
music = pdbpm.newTrack()
```

The `update(dt)` method of each track should be called from within the
`playdate.update()` function:

```lua
function playdate.update(dt)
  music:update(dt)
end
```

The track's `load()` method should be called to load in the music. The load
method takes a single argument: the music's filename or a `SoundData` object.
The `setBPM()` method should be called with the BPM of the loaded track.

```lua
music:load("loop.wav")
music:setBPM(127)
```

An event handler function for the `beat` event can be set. This will be called
at the start of each beat when the song is playing, the beat number is passed to
the handler function.

```lua
music:on("beat", function(n) print("beat:", n) end)
```

The music can be played by using the `play()` method.

```lua
music:play()
```

See the [demo](demo) directory for a small example project.


## Functions
#### pdbpm.newTrack()
Creates and returns a new `Track` object.

#### pdbpm.detectBPM(filename [, opts])
Tries to detect the BPM of a looped song. `filename` can be a filename or
`SoundData` object. An `opts` table can be provided with additional options,
consisting of the following:

 Name        | Default  | Description
-------------|----------|-------------------------------------------------------
 `minbpm`    | 75       | Minimum allowed BPM
 `maxbpm`    | 300      | Maximum allowed BPM

#### Track:load(filename)
Loads an audio file or `SoundData` object.

#### Track:setBPM(n)
Sets the BPM of the current track; this is used when calculating the current
beat.

#### Track:setVolume([volume])
Sets the volume of the track, by default this is `1`.

#### Track:setPitch([pitch])
Sets the pitch of the track, by default this is `1`.

#### Track:setLooping([loop])
Sets whether the track should loop when it reaches the end. By default this is
`false`.

#### Track:setOffset([n])
Offsets the track's timing by `n` seconds. This function can be used to
compensate for audio latency. By default this is `0`.

#### Track:on(name, fn)
Sets an event handler for the event of the given `name`. The `on()` function can
be called several times for the same event to set multiple handlers. The events
which can be emitted by a track are as follows:

 Name     | Description                                 | Arguments
----------|---------------------------------------------|-----------------------
 `beat`   | The start of a beat has occurred            | `current_beat`
 `update` | The track's update() function was called    | `track_delta_time`
 `loop`   | The track has reached the end and looped    |
 `end`    | The track has reached the end and stopped   |


#### Track:play([restart])
Plays the track if it is stopped or paused. If `restart` is `true` then the
track starts playing from the beginning.

#### Track:pause()
Pauses the track's progress, but retains the current play-position of the track.

#### Track:stop()
Stops the track, reseting the current play-position to the beginning.

#### Track:setTime(n)
Sets the current play-position of the track to `n` seconds.

#### Track:setBeat(n)
Sets the current play-position of the track to the given beat number.

#### Track:getTotalTime()
Returns the length of the track in seconds.

#### Track:getTotalBeats()
Returns the total number of beats in the track.

#### Track:getTime()
Returns the current play-position of the track.

#### Track:getBeat([multiplier])
Returns the current beat and subbeat of the track. For example, if the track is
exactly half way between beats 3 and 4, the values `3` and `0.5` will be
returned:

```lua
local beat, subbeat = music:getBeat()
```

#### Track:update()
Updates the track's internal state, and emits events if required. This should be
called from the `love.update()` function.


## License
This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
