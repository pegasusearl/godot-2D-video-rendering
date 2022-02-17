# Description

This is tool to render 2D scene you made with godot. If you are comfortable making animations or compositing in godot than in other softwares. Maybe this tool is for you.

It's still under slow development. I plan to add alot of features which will make using this tool comfortable and FAST.

My goal with this tool is to mass-produce cheaply made animations to survive during game development.

# Todo list

## normal priority

- [x] Multi scene render (Batch Renderer)
- [ ] Batch Renderer: Different naming system for one straight sequence or separated per scene, for quick revision.
- [ ] Tutorial/Docs
- [ ] Demo

- [x] One By One Modulate node.
- [x] Watermark
- [ ] Save watermark state.
- [ ] For every track in AnimationRender check and add new key in first frame. By duplicating from first keyframe. (for now make sure to have keyframe in first frame for every track)
- [ ] Allow options to exclude last frame. If you render batch, you will notice that there is extra frames. It's because of the last frames.
- [ ] Add playback control to preview.

## low priority

- [ ] Batch Renderer: Continous offset mode. delta duration from previous scene will still count toward next file. (for weird timing.)
