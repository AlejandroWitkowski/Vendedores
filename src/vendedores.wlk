class Vendedor {
	const certificaciones  //lista de certificaciones
	
	method addCertificaciones(certificacion) = certificaciones.add(certificacion)
	
	method esVendedorVersatil() = self.cantidadCertificaciones() > 3 and self.tieneAlMenosUnaCertiProducto() and self.tieneAlMenosUnaCertiNoProducto()
	
	method cantidadCertificaciones() = certificaciones.size()
	
	method tieneAlMenosUnaCertiProducto() = certificaciones.any({certificacion => certificacion.esCertiDeProducto()})
	
	method tieneAlMenosUnaCertiNoProducto() = certificaciones.any({certificacion => not(certificacion.esCertiDeProducto())})
	
	method vendedorFirme() =  self.totalDePuntos()>= 30
	
	method totalDePuntos() = certificaciones.sum({certificacion => certificacion.cantidadPuntos()})
	
	method vendedorInfluyente() = false
	
	method puedeTrabajar(ciudad)
	
	method vendedorAfin(centro) = self.puedeTrabajar(centro.ciudadRadicacion())
	
	method cantidadCertificacionesPodruco() = certificaciones.count({certificacion => certificacion.esCertiDeProcuto()})
	
	method esPersonaFisica() = true
}

class VendedorFijo inherits Vendedor {
	const ciudadResidencia //Unica ciudad
	
	override method puedeTrabajar(ciudad) = ciudadResidencia == ciudad
	
}

class VendedorViajante inherits Vendedor{
	const provinciasHabilitadas //Una lista de provincias
	const limiteVendedorInfluyente = 10000000
	
	method addProvinciaHabilitada(provincia) = provinciasHabilitadas.add(provincia)
	
	override method puedeTrabajar(ciudad) = provinciasHabilitadas.contains(ciudad.provinciaPertenece())
	
	override method vendedorInfluyente()= self.poblacionTotalPorProvincia() >= limiteVendedorInfluyente
	
	method poblacionTotalPorProvincia() = provinciasHabilitadas.sum({provincia => provincia.poblacion()}) 
	
}

class ComercioCorresponsal inherits Vendedor{
	const sucursalesEnCiudad //Una lista de ciudades donde tiene sucursales
	
	method addCiudadDeLaSucursal(ciudad) = sucursalesEnCiudad.add(ciudad)
	
	override method puedeTrabajar(ciudad) = sucursalesEnCiudad.contains(ciudad)
	
	override method vendedorInfluyente() = sucursalesEnCiudad.size() >= 5 or self.totalProvinciasHaySucursales() >= 3
	
	method provinciasRadicacionSucursales() = sucursalesEnCiudad.map({ciudad => ciudad.provinciaPertence()})
	
	method totalProvinciasHaySucursales() = self.provinciasRadicacionSucursales().size()
	
	override method vendedorAfin(centro) = 	super(centro) and not(sucursalesEnCiudad.any({sucursal => centro.puedeCubrir(sucursal)}))
	
	override method esPersonaFisica() = false	
	
}

class Ciudad {
	const provinciaPertenece
}

class Provincia {
	const poblacion
}

class Certificacion{
	const certProducto //indicar true o false si la certificacion es de producto o no
	
	method esCertiDeProducto() = certProducto
	
	method cantidadPuntos(){}
	
}

class CentroDistribucion{
	const property ciudadRadicacion
	const vendedoresTrabajan //Lista de vendedores
	
	method agregarVendedor(vendedor){
		if(self.vendedorEstaRegistrado(vendedor)) {self.error("El vendedor ya se encuentra registrado")}
		vendedoresTrabajan.add(vendedor)
	}
	
	method vendedorEstaRegistrado(vendedor) = vendedoresTrabajan.contains(vendedor)
	
	method vendedorEstrella() = vendedoresTrabajan.max({vendedor => vendedor.totalDePuntos()})
	
	method puedeCubrirCiudad(ciudad) = vendedoresTrabajan.any({vendedor => vendedor.puedeTrabjar(ciudad)})
	
	method vendedoresGenericos() = vendedoresTrabajan.filter({vendedor => vendedor.tieneAlMenosUnaCertiNoProducto()})
	
	method centroRobusto() = vendedoresTrabajan.count({vendedor => vendedor.vendedorFirme()}) >= 3
	
	method repartirCertificacion(certificacion) = vendedoresTrabajan.forEach({vendedor => vendedor.addCertificaciones(certificacion)})
	
	method tieneAfinidad(vendedor) = vendedor.vendedorAFin(self)
	
	method vendedorCandidato(vendedor) = self.tieneAfinidad(vendedor) and vendedor.esVendedorVersatil()	
}

object clienteInseguro{
	method mePuedenAtender(vendedor) = vendedor.esVendedorVersatil() and vendedor.vendedorFirme()
}

object clienteDetallista{
	method mePuedenAtender(vendedor) = vendedor.cantidadCertificacionesPodruco() >= 3
}

object clienteHumanista{
	method mePuedenAtender(vendedor) = vendedor.esPersonaFisica()
}