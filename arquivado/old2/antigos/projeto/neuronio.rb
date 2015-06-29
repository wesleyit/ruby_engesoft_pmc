#!/usr/bin/env ruby
# ***********************************************************************
# Coding: utf-8
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: Neuronio artificial parte de uma rede perceptron MC
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

class Neuronio
	attr_accessor :entradas
	attr_accessor :pesos
	attr_accessor :resposta
	attr_accessor :erro
	attr_accessor :gradiente
	
	def initialize
		@pesos = []
		@erro = nil
		@resposta = 1
	end
	
	def processa(entradas)
		@entradas = entradas
		@pesos = @entradas.map {|i| (i * rand(0.1..1.0)) } if @pesos.length == 0
		@ativacao = ativacao
		@derivada_ativacao = derivada_ativacao
		@resposta = transferencia
		puts "Entradas: #{@entradas}, Pesos: #{@pesos}, Resposta: #{@resposta}."
		return @resposta
	end
	
	def ativacao
		@ativacao = 0
		@entradas.index {|i| @ativacao += @entradas[i] * @pesos[i] }
		@ativacao += $bias
		return @ativacao
	end
	
	def transferencia
		return Math.tanh(@ativacao)
	end
	
	def derivada_ativacao
		return (1 - Math.tanh(@ativacao) ** 2)
	end
	
	def gradiente
		@gradiente = @erro * @derivada_ativacao
		return @gradiente
	end
	
	def ajusta_pesos
		puts "Pesos errados: #{@pesos}, "
		@pesos.each_index do |i|
			@delta_peso = ($taxa_aprendizado * gradiente * @entradas[i])
			print "Delta#{i}: #{@delta_peso}, "
			@pesos[i] += @delta_peso
		end
		puts "\nPesos atualizados: #{@pesos}, "
	end
	
	
end

