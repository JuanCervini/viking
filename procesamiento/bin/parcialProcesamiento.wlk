
class SuperComputadora{
	const equipos = []
	var totalComplejidadComputada

	method equiposActivos() = equipos.filter{equipo => equipo.estaActivo()}
	method estaActivo() = true
	
	
	method consumo() = self.equiposActivos().sum{equipo => equipo.consumo()} 
	method computo() = self.equiposActivos().sum{equipo => equipo.computo()} 
	
	method masConsumidora() = self.equiposActivos().max{ equipo => equipo.consumo() }	
	method masComputa() = self.equiposActivos().max{ equipo => equipo.computa() }	
	
	method malConfigurada() = self.masConsumidora() != self.masComputa()
	
	method computar(problema) { self.equiposActivos().forEach {equipo => equipo.computar(new Problema (complejidad =
			problema.complejidad() / self.equiposActivos().size()))}
			
			totalComplejidadComputada += problema.complejidad()
	}
}

class Equipo{
	var property modo = standard
	var property estaQuemado = false
	
	method computo() = modo.computoDe(self)
	method consumo() = modo.consumoDe(self)
	
	method conputoBaseS()
	method consumoBaseS()
	
	method condicionComputoO()
	
	method computar(problema) {
		if(problema.complejidad() > self.computo()) throw new DomainException(message="Capacidad excedida")
		
		modo.realizoComputo(self)
	}
}

class A105 inherits Equipo {
	
	override method conputoBaseS() = 600
	override method consumoBaseS() = 300
	
	override method condicionComputoO() = self.conputoBaseS() * 1.3
	
	override method computar(problema) {
		if(problema.complejidad() < 5) throw new DomainException(message="Error de Fabrica")
		
		super(problema)
	}
}

class B2 inherits Equipo {
	const microsInstalados
	
	override method conputoBaseS() = 800.min(100 * microsInstalados)
	override method consumoBaseS() = 10 + 50 * microsInstalados
	
	override method condicionComputoO() = microsInstalados * 20
	
} 

object standard {
	
	method computoDe(equipo) = equipo.computoBase()
	
	method consumoDe(equipo) = equipo.consumoBase()
	
	method realizoComputo(equipo) { }
}

class Overclock {
	var usosRestantes
	
	
	method computoDe(equipo) = equipo. conputoBase() + equipo.condicionComputoO()
	
	method consumoDe(equipo) = 2 * equipo.consumoBase()
	
	method realizoComputo(equipo) {
		if(usosRestantes == 0){
			equipo.estaQuemado(true)
			throw new DomainException(message = "Equipo quemado")}
		usosRestantes -= 1
	}
}

class AhorroDeEnergia {
	var computosRealizados = 0
	
	method computoDe(equipo) = self.consumoDe(equipo) / equipo.consumoBase() * equipo.computoBase()
	
	method consumoDe(equipo) = 200
	
	method periodicidadDeError() = 17
	
	method realizoComputo(equipo) {
		computosRealizados += 1
		if(computosRealizados % self.periodicidadDeError() == 0)throw new DomainException(message = "Corriendo monitor")
	}
}

class APruebaDeFallos inherits AhorroDeEnergia {
	
	override method computoDe(equipo) = super(equipo) / 2 
	
	override method periodicidadDeError() = 100
}

class Problema {
	const property complejidad
	
}







