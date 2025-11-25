extends Node
class_name ObjectPool

var object: PackedScene
var num_objetos: int
var nome: String
var lista_obj: Array = []
var parent_node: Node

func _init(objeto: PackedScene, num_objetos: int, nome: String) -> void:
	self.object = objeto;
	self.num_objetos = num_objetos;
	self.nome = nome;


func _ready() -> void:
	instancia_objetos();

func instancia_objetos() -> void:
	for i in range(num_objetos):
		var instancia = object.instantiate();
		instancia.name = nome + str(i);
		desativar(instancia)
		lista_obj.append(instancia);
		add_child(instancia)

func desativar(objeto: Node2D) -> void:
	objeto.hide();
	objeto.set_physics_process(false);


func ativar(objeto: Node2D) -> void:
	objeto.show()
	objeto.set_physics_process(true);

func get_from_pool() -> Node2D:
	for objeto in lista_obj:
		if not objeto.is_visible():
			ativar(objeto);
			return objeto;
	return null

func return_to_pool(objeto: Node2D) -> void:
	desativar(objeto)
