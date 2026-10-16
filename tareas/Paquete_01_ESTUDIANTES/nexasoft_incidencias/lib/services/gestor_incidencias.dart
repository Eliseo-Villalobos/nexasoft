import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  final AlmacenLocal datos = AlmacenLocal();
  List<Incidencia> incidencias = [];
  //aqui esta parte del tercer bug
  //se elimina este contador para mejor contar a partir de la lista  de incidencias 
  //int cantidadPendientes = 0;

  Future<void> iniciar() async {
    incidencias = await datos.leer();
    //aqui esta parte del terer bug
    //se elimina esta inicializacion de los casos pendientes para mejor solo contar a partir de la lista de incidencias y no aparte
    //cantidadPendientes =
        //incidencias.where((x) => x.estado == 'Pendiente').length;
  }
  //aqui esta parte del segundo bug
  //List<Incidencia> buscar(String texto) {
    //if (texto.trim().isEmpty) return incidencias;
    //esta funcion solo esta detectando con el contains el titulo, pero no la descripcion
    //return incidencias.where((x) => x.titulo.contains(texto)).toList();
  //}
  //nueva funcion en la que agregamos que coincida con el titulo y tambien con la descripcion
  List<Incidencia> buscar(String texto) {
    final consulta = texto.trim().toLowerCase();
    if (consulta.isEmpty) return incidencias;
    return incidencias
        .where((x) =>
            x.titulo.toLowerCase().contains(consulta) ||
            x.descripcion.toLowerCase().contains(consulta))
        .toList();
  }
  
  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }

  int contar(String estado) {
    //aqui esta parte del tercer bug
    //se quita el condicional para solo contar a partir de la lista y su lenght y no tener los estados pendientes aparte
    //if (estado == 'Pendiente') return cantidadPendientes;
    return incidencias.where((x) => x.estado == estado).length;
  }
  //aqui esta parte del primer bug
  //agregar una llamada a guardar para solucionar el bug
  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].estado = estado;
        break;
      }
    }
    //esto se agrego para poder guardar el cambio realizado
    await datos.guardar(incidencias);
  }

  Future<void> crear(String titulo, String descripcion, String cliente,
      String categoria) async {
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      fecha: DateTime.now().toIso8601String().split('T').first,
    );
    incidencias.insert(0, nuevo);
    //cantidadPendientes++;
    await datos.guardar(incidencias);
  }

  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
