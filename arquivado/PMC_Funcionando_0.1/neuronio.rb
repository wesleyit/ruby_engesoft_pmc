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

class Neuronio
	attr_accessor :entradas_ajustadas
	attr_accessor :parcela_do_erro
	attr_accessor :gradiente
	attr_accessor :taxa_de_aprendizagem
	attr_accessor :derivada_da_ativacao
	attr_accessor :saida
	attr_accessor :peso_bias

	def initialize(tipo)
		@entradas_ajustadas = []
		@peso_bias = rand($range_peso_bias)
		@parcela_do_erro = []
		@taxa_de_aprendizagem = $taxa_de_aprendizagem
		@tipo = tipo
	end
	
	def calcula_ativacao()
		if @tipo == :linear
			@saida = (@entradas_ajustadas.inject {|n1, n2| n1 + n2} + $bias * @peso_bias) if $usar_bias == true
			@saida = (@entradas_ajustadas.inject {|n1, n2| n1 + n2}) if $usar_bias == false
			@entradas_ajustadas = []
		elsif @tipo == :hiperbolica
			@saida = Math.tanh(@entradas_ajustadas.inject {|n1, n2| n1 + n2} + $bias * @peso_bias) if $usar_bias == true
			@saida = Math.tanh(@entradas_ajustadas.inject {|n1, n2| n1 + n2}) if $usar_bias == false
			@entradas_ajustadas = []	
		end
	end
	
	def calcula_derivada_e_gradiente()
		@derivada_da_ativacao = 1 if @tipo == :linear
		@derivada_da_ativacao = 1 - (@saida ** 2) if @tipo == :hiperbolica
		@gradiente = @derivada_da_ativacao * @parcela_do_erro.inject {|n1, n2| n1 + n2} ## calcula o gradiente somando as parcelas de erro
		@peso_bias = @peso_bias + @taxa_de_aprendizagem * @gradiente ## atualiza o peso do bias
		@parcela_do_erro = [] ## limpa o erro depois de gerar o gradiente
	end
end

