# Guidot
Guidot is a GDScript library for building user interfaces with [Godot Engine](https://github.com/GodotEngine) 4.

Guidot is library inspired by React that aims to improve the application development workflow with Godot Engine 4, providing a similar aproach to building web apps.
Guidot allows to build modular applications base on components.  Guidot will update all control nodes that need to change when the data of the components are updated. 
This library takes advantage of the already powerful control nodes system of Godot and improves it with a more readable and maintainable code.

```gdscript
extends Component
class_name Counter

func _init():
  super("counter")
  state = {count=0}

func increment():
  state.count += 1
  update_view()

func view():
  return\
  Gui.center({preset="full"}, [
    Gui.button({
      text=str(state.count)
      on_pressed=increment
    })
  ])
```
## IMPORTANT
This library is not ready for serious projects, some parts of the code contain naive solutions, not all control nodes have been tested and remember, Godot 4 is in alpha.
* Currently working with Godot 4 alpha 14.

## Demos
* [guidot-docs](https://github.com/andresgamboaa/guidot-docs)
* [guidot-movies](https://github.com/andresgamboaa/guidot-movies)

## Installation
```bash
git clone https://github.com/andresgamboaa/guidot.git
```
Copy the guidot folder to your project and enable the Guidot, Gui and Utils singletons (Autoload)

# Contributing to this project
In case you want to suggest improvements to this addon or fix issues, feel free to raise a pull request or raise an issue!


## Support me
[Buy me a Coffee](https://ko-fi.com/andres36)
