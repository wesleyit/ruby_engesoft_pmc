#!/usr/bin/env ruby
# Coding: utf-8
# ***********************************************************************
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: OOPMC - Perceptron Multicamadas Orientado a Objetos
# Version: 0.1
# ***********************************************************************
#  
#  Copyright 2014 Wesley Rodrigues da Silva <wesley.it@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

class Conexao
	attr_accessor :peso
	def initialize(origem, destino)
		@peso = rand($range_peso_conexao)
		@peso_anterior = @peso
		@neuronio_de_origem = origem
		@neuronio_de_destino = destino
	end
	
	def propaga_adiante()
		@neuronio_de_destino.entradas_ajustadas << @neuronio_de_origem.saida * @peso
	end
	
	def retropropaga()
		@delta_peso = ($taxa_de_momentum * (@peso - @peso_anterior)) + (@neuronio_de_destino.taxa_de_aprendizagem * @neuronio_de_destino.gradiente * @neuronio_de_origem.saida)
		@peso_anterior = @peso
		@peso = @peso + @delta_peso
		@neuronio_de_origem.parcela_do_erro << @neuronio_de_destino.gradiente * @peso
	end
end

