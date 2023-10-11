![Alt text](images/goduz_logo.png?raw=true "Title")
# Goduz
Goduz is a GDScript library for building user interfaces with [Godot Engine](https://github.com/GodotEngine) 4.

Inspired by React, Goduz allows to build modular applications base on components. Define
views for each state of your application and Goduz will update and render just the right control nodes when your data changes. 
This library takes advantage of the already powerful control nodes of Godot.

```gdscript
class_name Counter extends Component

func _init():
	super()
	state.count = 0

func decrease(): state.count -= 1
func increase(): state.count += 1

func view():
	return\
	hbox({preset="center"},[
		button({text="-", on_pressed=decrease}),
		label({text=str(state.count)}),
		button({text="+", on_pressed=increase}),
	])
```

## Installation

```bash
git clone https://github.com/andresgamboaa/goduz.git
```

1. Copy the goduz folder to the addons folder of your project.
2. Enable this addon within the Godot settings: Project > Project Settings > Plugins
3. Add the RootComponent node to a control node in your scene.

## Examples

[Goduz Notes](https://github.com/andresgamboaa/goduz-notes)

## IMPORTANT
This library is not ready for serious projects, some parts of the code contain naive solutions and not all control nodes and cases have been tested.
* Currently working with Godot 4 beta 2.

## Contributing
In case you want to suggest improvements or fix issues, feel free to raise a pull request or raise an issue.
