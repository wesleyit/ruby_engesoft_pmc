#!/usr/bin/env ruby
# Coding: utf-8
# ***********************************************************************
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: 
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

$limite_de_epocas = 1000
$taxa_de_aprendizagem = 0.3

class Camada
	attr_accessor :neuronios
	def initialize(qtd_neuronios)
		@neuronios = []
		qtd_neuronios.times { @neuronios << Neuronio::new }
	end
end

class Neuronio
	attr_accessor :conexoes_ida
	attr_accessor :conexoes_volta
	attr_accessor :entradas
	attr_accessor :saida
	attr_accessor :gradiente
	attr_accessor :parcela_do_erro
	def initialize
		@conexoes_ida = []
		@conexoes_volta = []
		@entradas = []
		@parcela_do_erro = []
		@saida = 0
	end
	
	def executa
		@saida = Math.tanh(@entradas.inject { |n1, n2| n1 + n2})
		##puts "Sou o neuronio #{self}, recebi #{@entradas} e respondi #{@saida}"
		return @saida
	end
	
	def ajusta_pesos
		@gradiente = @parcela_do_erro.inject { |n1, n2| n1 + n2 } * ((1 - @saida)**2)
		@parcela_do_erro = []
	end
end

class Conexao
	attr_accessor :peso
	def initialize(neuronio_origem, neuronio_destino)
		@neuronio_origem = neuronio_origem
		@neuronio_destino = neuronio_destino
		@neuronio_origem.conexoes_ida << self
		@neuronio_destino.conexoes_volta << self
		@peso = rand(-0.5..0.5)
	end

	def propaga
		@neuronio_destino.entradas = []
		@neuronio_destino.entradas << @neuronio_origem.saida * @peso
	end
	
	def retropropaga
		@peso = @peso + $taxa_de_aprendizagem * @neuronio_destino.gradiente * @neuronio_origem.saida
		@neuronio_origem.parcela_do_erro << @neuronio_destino.gradiente * @peso
	end
end


class Rede
	attr_accessor :saidas_da_rede
	def initialize(formato)
		@camadas = []
		@conexoes = []
		@entradas_da_rede = []
		formato.each { |n| @camadas << Camada::new(n) }
		conecta
		##puts self.inspect.gsub(" ","\n")
	end
	
	def executa(vetor_de_execucao)
		@entradas_da_rede = vetor_de_execucao
		@saidas_da_rede = []
		propaga
		@camadas.last.neuronios.each { |n| @saidas_da_rede << n.saida }
		return @saidas_da_rede
	end

	def treina(vetor_de_treino)
		@epocas = 0
		@erro_acumulado = []
		loop do
			puts "\nÉpoca #{@epocas}"
			vetor_de_treino.each do |treino|
				@valores_de_teste = treino[0]
				@respostas_desejadas = treino[1]
				@respostas_obtidas = executa(@valores_de_teste)
				@erro_local = @respostas_desejadas.zip(@respostas_obtidas).map { |n1, n2| n1 - n2}
				@erro_acumulado << @erro_local
				retropropaga
				puts "Entrada: #{@valores_de_teste}, Desejado: #{@respostas_desejadas}, Obtido: #{@respostas_obtidas}, Erro: #{@erro_local}"
			end
			@epocas += 1
			puts @erro_medio_quadratico = (@erro_acumulado.flatten.map { |x| x**2 }).inject {|n1, n2| n1 + n2} / 2
			@erro_acumulado = []
			break if @erro_medio_quadratico < 0.001
			break if @epocas > $limite_de_epocas 
		end
	end

	def conecta
		@camadas.each_with_index do |camada_origem, indice|
			break if camada_origem == @camadas.last
			camada_origem.neuronios.each do |neuronio_origem|
				@camadas[indice + 1].neuronios.each do |neuronio_destino|
					@conexoes << Conexao::new(neuronio_origem, neuronio_destino) 
				end
			end	
		end
	end

	def propaga
		@camadas.each do |camada|
			camada.neuronios.each do |neuronio|
				neuronio.entradas = @entradas_da_rede if camada == @camadas.first	
				neuronio.executa
				neuronio.conexoes_ida.each do |conexao|
					conexao.propaga
				end
			end
		end
	end

	def retropropaga
		@camadas.reverse_each do |camada|
			camada.neuronios.each_with_index do |neuronio, indice|
				neuronio.parcela_do_erro << @erro_local[indice] if camada == @camadas.last
				neuronio.ajusta_pesos
				neuronio.conexoes_volta.each do|conexao|
					conexao.retropropaga
				end
			end
		end
	end	
end



rede = Rede::new([2, 2, 2])
treino_xor = [ [[0, 0], [0, 0]], [[0, 1], [1, 1]], [[1, 0], [1, 1]], [[1, 1], [0, 0]] ]
rede.treina(treino_xor)




