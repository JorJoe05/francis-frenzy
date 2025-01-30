class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()
@export var states : Dictionary = {}

@onready var state: State = get_node(initial_state)

func _get_configuration_warnings():
	if get_child_count() <= 0:
		return ["No States found, please add at least one State."]
	for child in get_children():
		if not child is State:
			return ["NOTE: Any node that does not extend from 'State' will be ignored."]

func _ready() -> void:
	await owner.ready
	self.child_entered_tree.connect(_update_states)
	self.child_exiting_tree.connect(_update_states)
	self.child_order_changed.connect(_update_states)
	_update_states()
	if not Engine.is_editor_hint():
		state.enter()

func _unhandled_input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		state.handle_input(event)

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state.update(delta)

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state.physics_update(delta)

func _update_states(node = null) -> void:
	for child in get_children():
		if child is State:
			var state_name : StringName = StringName(child.name)
			states[state_name] = get_path_to(child)
			if not Engine.is_editor_hint():
				child.state_machine = self

func transition_to(target_state_name: StringName, msg: Dictionary = {}) -> void:
	if not Engine.is_editor_hint():
		assert(states.has(target_state_name))
		
		state.exit()
		state = get_node(states[target_state_name])
		state.enter(msg)
		emit_signal("transitioned", target_state_name)

func get_state() -> StringName:
	return state.name

func get_state_as_node() -> State:
	return state
