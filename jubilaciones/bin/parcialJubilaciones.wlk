
class Trabajador {
	var lenguajes = []
	
	method sabeProgramarLenguajeAntiguo() = lenguajes.any{lenguaje => lenguaje.esAntiguo()}
	
	method cantidadLenguajesModernos() = lenguajes.count{l =>not l.esAntiguo()}
	
	method nroMesa() = self.cantidadLenguajesModernos()
	
	method regalo() = 1000 * self.cantidadLenguajesModernos()
}

class Desarrollador inherits Trabajador {
	
	method sabeProgramarWollok() = lenguajes.any{lenguaje => lenguaje.esWollok()}
	
	method califica() = self.sabeProgramarLenguajeAntiguo()
	
	method esInvitado() = self.sabeProgramarWollok() || self.sabeProgramarLenguajeAntiguo()
}

class Infraestructura inherits Trabajador {
	var experiencia
	
	method sabeMuchosLenguajes() = lenguajes.size() >= 5
	
	method califica() = experiencia > 10
	
	method esInvitado() = self.sabeMuchosLenguajes()
}

class Jefe inherits Trabajador {
	const personasACargo = []
	
	method tieneACargoAlguienQueCalifica() = personasACargo.any{p => p.califica()}
	
	method califica() = false
	
	method esInvitado() = self.sabeProgramarLenguajeAntiguo() && 
						  self.tieneACargoAlguienQueCalifica() 
						  
	override method nroMesa() = 99
	
	override method regalo() = 1000 * personasACargo.size()
}

object lenguaje{
	var nombre
	var property esAntiguo = true
	
	method esWollok() = nombre == "wollok"
}

object empresa {
	const empleados = []

	method listaDeInvitados() =
		empleados.filter{ e => e.esInvitado() }
}

object fiesta {

	const asistencias = []
	method llegaInvitado(alguien){

		if(!empresa.listaDeInvitados().contains(alguien)) 
			throw new NoInvitadoException(message="no te invitaron")

		asistencias.add(
			new Asistencia(
				invitado = alguien,
				nroOrden = self.nroOrden(),
				nroMesa = alguien.nroMesa()
			)
		)
	}
	method nroOrden() = asistencias.size() + 1

	method balance() = self.ingresos() - self.gastos()
	method ingresos() = asistencias.sum{a=>a.regalo()}
	method gastos() = 200000 + asistencias.size() * 5000

	method esExcelente() = 
		empresa.listaDeInvitados().all{invitado=> 
			self.asistio(invitado)
		}
	method asistio(alguien) = 
		asistencias.any{a=> a.invitado() == alguien}

	method sorteo() { 
		const ganador = (1..self.nroOrden()-1).anyOne()
		return asistencias.find{a=>a.nroOrden() == ganador}
	}
}

class NoInvitadoException inherits Exception{

}

class Asistencia {
	var property invitado
	var property nroOrden
	var nroMesa 

	method regalo() = invitado.regalo()
}
