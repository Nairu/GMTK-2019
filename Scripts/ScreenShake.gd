extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

export(float) var amplitude = 0
export(int) var priority = 0

onready var camera = get_parent()

func _ready():
	$Duration.connect("timeout", self, "_on_Duration_timeout")
	$Frequency.connect("timeout", self, "_on_Frequency_timeout")

func start(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if priority >= self.priority:
		self.amplitude = amplitude
		self.priority = priority
		$Duration.set_wait_time(duration)
		$Frequency.set_wait_time(1 / float(frequency))
		$Duration.start()
		$Frequency.start()
		
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
func _reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
	priority = 0
	
func _on_Frequency_timeout():
	_new_shake()
	
func _on_Duration_timeout():
	_reset()
	$Frequency.stop()