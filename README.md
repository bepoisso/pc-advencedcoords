# PC Advanced Coordinates

A FiveM resource for selecting and copying Vector3 coordinates with a visual marker. Supports both clipboard copy and export functionality for other scripts.

## Features

- 🎯 Visual marker that follows your camera aim
- 📋 Copy coordinates directly to clipboard
- 🔌 Export function for integration with other scripts
- 🎨 Persistent UI instructions using ox_lib
- 🔴 Red sphere marker for precise coordinate selection

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib) - Required for clipboard, notifications, and UI

## Installation

1. Download and place the resource in your server's `resources` folder
2. Ensure ox_lib is installed and started before this resource
3. Add to your `server.cfg`:
```cfg
ensure ox_lib
ensure pc-advencedcoords
```

## Usage

### Command Mode (Copy to Clipboard)

Use the `/coords` command to activate coordinate selection:

1. Type `/coords` in chat
2. A red marker will appear where your camera is pointing
3. Move your camera to position the marker where you want
4. Press **E** to copy the coordinates to your clipboard
5. Paste the coordinates anywhere (format: `vector3(x, y, z)`)

### Export Mode (For Developers)

Use the export function to integrate coordinate selection into your own scripts:

```lua
exports['pc-advencedcoords']:selectCoords(function(coords)
    -- coords is a vector3 object
    print('Selected coordinates:', coords)
    print('X:', coords.x, 'Y:', coords.y, 'Z:', coords.z)
end)
```

## How It Works

1. The script uses raycasting from the camera to detect surfaces
2. A red marker (sphere) is drawn at the raycast hit point
3. If no surface is detected, the marker appears 2 units in front of the player
4. When **E** is pressed:
   - **Command mode**: Coordinates are copied to clipboard with notification
   - **Export mode**: Coordinates are passed to the callback function

## Configuration

You can modify the following in `client/client.lua`:

- **Marker distance**: Change `local distance = 10.0` (line 43)
- **Fallback distance**: Change `markerCoords = playerCoords + camDir * 2.0` (line 52)
- **Marker appearance**: Modify the `DrawMarker` parameters (line 56)
- **Key binding**: Change `IsControlJustPressed(0, 38)` (line 60) - 38 is E key

## License

Free to use and modify.

## Credits

- **Author**: Flitcher
- **Version**: 1.0.0
