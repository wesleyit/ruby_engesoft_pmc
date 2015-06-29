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

class Camada
	attr_accessor :neuronios
	attr_accessor :conexoes_para_frente
	attr_accessor :conexoes_para_tras
	
	def initialize(ultima, neuronios)
		@neuronios = []
		@conexoes_para_frente = []
		@conexoes_para_tras = []
		if $tipo_de_rede == :hiperbolica
			neuronios.times {@neuronios << Neuronio::new(:hiperbolica)}
		elsif $tipo_de_rede == :linear
			neuronios.times {@neuronios << Neuronio::new(:linear)}
		elsif $tipo_de_rede == :hiper_linear
			if ultima == true
				neuronios.times {@neuronios << Neuronio::new(:linear)}
			else
				neuronios.times {@neuronios << Neuronio::new(:hiperbolica)}
			end
		end
	end
	
	def propaga_adiante()
		@neuronios.each {|n| n.calcula_ativacao}
	end
	
	def retropropaga()
		@neuronios.each {|n| n.calcula_derivada_e_gradiente}
	end
end

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
require './rede.rb'
require './camada.rb'
require './neuronio.rb'
require './conexao.rb'


## Definições: Estes parâmetros serão acessíveis via formulário pelo 
# Sinatra
$limite_de_epocas = 2000
$taxa_de_aprendizagem = 0.05
$erro_aceitavel = 0.0001
$taxa_de_momentum = 0.95
$usar_bias = true
$bias = 1
$range_peso_bias = (-0.5..0.5)
$range_peso_conexao = (-0.5..0.5)
$debug = false
$tipo_de_rede = :hiperbolica
$arredondar_saida = true
$rede_treinada = false
# ***********************************************************************






## Fluxo de Execução ****************************************************

## @padrao = [ [[], []], [[], []], [[], []], [[], []] ]

rede = Rede::new([2, 1])
@padrao = [ [[0, 0], [0]], [[0, 1], [1]], [[1, 0], [1]], [[1, 1], [1]] ]
rede.treina(@padrao)

puts "\n\n\n--"
puts "Entrando 0, 0: #{rede.executa([0, 0])}"
puts "Entrando 0, 1: #{rede.executa([0, 1])}"
puts "Entrando 1, 0: #{rede.executa([1, 0])}"
puts "Entrando 1, 1: #{rede.executa([1, 1])}"


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
		@saida = @saida.round(1) if $arredondar_saida == true
	end
	
	def calcula_derivada_e_gradiente()
		@derivada_da_ativacao = 1 if @tipo == :linear
		@derivada_da_ativacao = 1 - (@saida ** 2) if @tipo == :hiperbolica
		@gradiente = @derivada_da_ativacao * @parcela_do_erro.inject {|n1, n2| n1 + n2} ## calcula o gradiente somando as parcelas de erro
		@peso_bias = @peso_bias + @taxa_de_aprendizagem * @gradiente ## atualiza o peso do bias
		@parcela_do_erro = [] ## limpa o erro depois de gerar o gradiente
	end
end

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
end




