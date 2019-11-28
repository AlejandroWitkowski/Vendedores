class Vendedor {
	const certificaciones  //lista de certificaciones
	
	
	method vendedorVersatil() = certificaciones.size() >= 3
	
	
	method vendedorFirme() =  self.totalDePuntos()>= 30
	
	method totalDePuntos() = certificaciones.sum({certificacion => certificacion.cantidadPuntos()})
	
	method vendedorInfluyente() = false
}

class VendedorFijo inherits Vendedor {
	const ciudadResidencia //Unica ciudad
	
	method puedeTrabajar(ciudad) = ciudadResidencia == ciudad
	
	
	
}

class VendedorViajante inherits Vendedor{
	const provinciasHabilitadas //Una lista de provincias
	const limiteVendedorInfluyente = 10000000
	
	method addProvinciaHabilitada(provincia) = provinciasHabilitadas.add(provincia)
	
	method puedeTrabajar(ciudad) = provinciasHabilitadas.contains(ciudad.provinciaPertenece())
	
	override method vendedorInfluyente()= self.poblacionTotalPorProvincia() >= limiteVendedorInfluyente
	
	method poblacionTotalPorProvincia() = provinciasHabilitadas.sum({provincia => provincia.poblacion()}) 
	
}

class ComercioCorresponsal inherits Vendedor{
	const sucursalesEnCiudad //Una lista de ciudades donde tiene sucursales
	
	method addCiudadDeLaSucursal(ciudad) = sucursalesEnCiudad.add(ciudad)
	
	method puedeTrabajar(ciudad) = sucursalesEnCiudad.contains(ciudad)
	
	override method vendedorInfluyente() = sucursalesEnCiudad.size() >= 5 or self.totalProvinciasHaySucursales() >= 3
	
	method provinciasRadicacionSucursales() = sucursalesEnCiudad.map({ciudad => ciudad.provinciaPertence()})
	
	method totalProvinciasHaySucursales() = self.provinciasRadicacionSucursales().size()
}

class Ciudad {
	const provinciaPertenece
}

class Provincia {
	const poblacion
}

object certificacion{
	const certProducto //indicar true o false si la certificacion es de producto o no
	
	method cantidadPuntos(){}
	
}