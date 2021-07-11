extends "res://scenes/abilities/unit/active.gd"

export var damage = 8

func _execute(board, position):
    var tile = board.map.model.get_tile(position)
    self.source.sfx_effect("attack")
    
    tile.unit.tile.receive_damage(self.damage)
    if not tile.unit.tile.is_alive():
        var unit_id = tile.unit.tile.get_instance_id()
        var unit_side = tile.unit.tile.side
        board.events.emit_unit_destroyed(self.source, unit_id, unit_side)
        board.destroy_unit_on_tile(tile)

    board.explode_a_tile(tile)

func is_tile_applicable(tile, _source_tile):
    return tile.has_enemy_unit(self.source.side)