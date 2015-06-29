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

class Rede
	attr_accessor :camadas
	def initialize(formato)
		@camadas = []
		formato.each_with_index do |n, i| 
			if i == (formato.length - 1)
				@ultima = true
			else
				@ultima = false
			end
			@camadas << Camada::new(@ultima, n)
		end
		@camadas.each_index do |i| ## cria as conexoes
			break if @camadas[i] == @camadas.last
			@camadas[i].neuronios.each do |nc1|
				@camadas[i + 1].neuronios.each do |nc2|
					@conexao = Conexao::new(nc1, nc2)
					@camadas[i].conexoes_para_frente << @conexao
					@camadas[i + 1].conexoes_para_tras << @conexao
				end
			end
		end
	end
	
	def lista_pesos
		@camadas.each_with_index do |c, i|
			puts "\nCamada #{i}"
			c.conexoes_para_frente.each { |cn| print "#{cn.peso} "}
			c.neuronios.each {|n| print "[#{n.peso_bias}] "}
		end
	end
	
	def executa(padrao)
		@camadas.first.neuronios.each {|n| n.entradas_ajustadas = padrao}
		@camadas.each do |c|
			c.propaga_adiante
			break if c == @camadas.last
			c.conexoes_para_frente.each {|con| con.propaga_adiante}
		end
		@resultado = []
		@camadas.last.neuronios.each {|n| @resultado << n.saida}
		return @resultado
	end
	
	def treina(padrao_de_treino)
		@epocas = 0
		@erro_medio_quadratico = 1000
		@soma_erros_quadraticos = []
		loop do
			puts "\nEpoca #{@epocas}" if $debug == true
			padrao_de_treino.each do |p|
				@resultados_obtidos = executa(p[0])
				@resultados_desejados = p[1]
				@erros_locais = @resultados_desejados.zip(@resultados_obtidos).map {|n1, n2| n1 - n2}
				@erros_locais.each_index {|i| @camadas.last.neuronios[i].parcela_do_erro << @erros_locais[i]}
				@erro_quadratico = 0.5 * ((@erros_locais.map{|erro| erro ** 2}).inject{|n1, n2| n1 + n2})
				@soma_erros_quadraticos << @erro_quadratico ## pega todos os erros quadraticos de uma época
				puts "X:#{p[0]}, d:#{@resultados_desejados}, Y:#{@resultados_obtidos}, Er:#{@erros_locais}, ErQ:#{@erro_quadratico}"  if $debug == true
				@camadas.reverse_each do |c|
					c.retropropaga
					c.conexoes_para_tras.each {|con| con.retropropaga}
				end
			end
			@erro_medio_quadratico = (@soma_erros_quadraticos.inject{|n1, n2| n1 + n2}) / @soma_erros_quadraticos.length
			puts "EMQ = #{@erro_medio_quadratico}"  if $debug == true
			@soma_erros_quadraticos = []
			@epocas += 1
			break if @epocas > $limite_de_epocas
			if @erro_medio_quadratico < $erro_aceitavel
				$rede_treinada = true; 
				puts "\n\n-------------------------------------------------------"
				puts "Rede treinada com sucesso na iteração #{@epocas}!"
				puts "-------------------------------------------------------"
				break
			end
		end
		lista_pesos
	end
	
	def salva(arquivo)
		File.open(arquivo, 'w') {|f| f.write(Marshal.dump(self)) }
	end
	
	def carrega(arquivo)
		@camadas = Marshal.load(File.read(arquivo)).camadas
	end
	
end




