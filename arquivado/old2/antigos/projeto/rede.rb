#!/usr/bin/env ruby
# ***********************************************************************
# Coding: utf-8
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: Rede Perceptron Multicamadas
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
	def initialize(dimensoes)
		@dimensoes = dimensoes
		@camadas = []
		@dimensoes.each { |d| @camadas << Camada::new(d) } ## cria e popula as camadas
	end
	
	def propaga_adiante
		@resposta = []
		@camadas.each_with_index do |c, i|
			c.entradas = @entradas if i == 0 ## se for a camada de entrada (0) os dados vem da própria entrada.
			c.entradas = @camadas[i-1].saidas if i > 0 ## se for uma camada oculta os dados vem da saída da camada anterior.
			@resposta = c.processa ## processa a entrada e salva a resposta em sua saída.
		end
		return @resposta
	end
	
	def processa(entradas)
		@entradas = entradas
		@saidas = []
		@saidas = propaga_adiante
		return @saidas
	end
	
	
	def linha
		puts " ---------------------------------------------------------------------------------------------------------------------------------------"
	end
	
	
	def ajusta_pesos_ocultos
		@indice = @camadas.length - 2
		until @indice < 0 do
			@camadas[@indice].neuronios.each_with_index do |n1, i1|
				n1.erro = 0
				@camadas[@indice + 1].neuronios.each_with_index do |n2, i2|
					n1.erro += n2.gradiente * n2.pesos[i1]
				end
			end
			@camadas[@indice].ajusta_pesos
			@indice -= 1
		end
	end
	
	def treina(padrao_de_treino)
		@padrao_de_treino = padrao_de_treino
		@erro_medio_quadratico = 1
		@obtido = []
		@epoca = 1
		
		loop do 
			linha
			## Inicia uma nova época
			puts "| EPOCA: #{@epoca}"
			## Zera os erros globais antes de cada época			
			@erro_global = []
			linha
			@padrao_de_treino.each_with_index do |p, i|
				
				## Processa a entrada dessa iteração e salva o array resultado em @obtido
				@obtido = processa(p[0])
				
				
				## Reinicializa os erros locais antes da iteração
				@erro_local = []

				
				## pega os erros locais de todas as saídas obtidas, e também insere nos neurônios
				## para calcular o gradiente mais tarde
				@obtido.each_index do |o|
					@erro_local[o] = (p[1][o] - @obtido[o])
					@camadas.last.neuronios.each do |n|
						n.erro = @erro_local[o]
					end
				end
				
				
				## Calcula o erro_global e salva no array
				@erro_global << @erro_local.map { |valor| valor ** 2 }.inject { |x, y| x + y } * 0.5
				


				puts "| Entrada: #{p[0]} | Esperado: #{p[1]} | Obtido: #{@obtido} "
				puts "| Erro_Local: #{@erro_local} | Erro_global: #{@erro_global.last} "
				linha
	
				begin	
					puts "Ajustando pesos..."
					## Ajusta os pesos da camada de saida
					@camadas.last.ajusta_pesos
					## Ajusta todos os outros pesos propagando o gradiente de erro
					ajusta_pesos_ocultos
				end if @erro_global.last !=	0
					
				linha

			end

			
			## Calcula o EMQ após o final de cada uma das épocas
			@erro_medio_quadratico = (@erro_global.inject { |y, z| y + z }) * ( 1.0 / @erro_global.length )
			puts "| Erro Médio Quadrático: #{@erro_medio_quadratico}"
			
			linha
			puts "\n\n\n"
			break if @erro_medio_quadratico.abs <= $precisao
			break if @epoca >= $limite_epocas
			@epoca += 1
		end

	end
end

