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
$limite_de_epocas = 5000
$taxa_de_aprendizagem = 0.005
$erro_aceitavel = 0.0001
$taxa_de_momentum = 1
$usar_bias = true
$bias = 1.0
$range_peso_bias = (-1.0..-1.0)
$range_peso_conexao = (-1.0..1.0)
$debug = true
$tipo_de_rede = :hiper_linear
# ***********************************************************************






## Fluxo de Execução ****************************************************

## @padrao = [ [[], []], [[], []], [[], []], [[], []] ]

rede = Rede::new([2, 2, 1])
treino_xor = [ [[0, 0], [0]], [[0, 1], [1]], [[1, 0], [1]], [[1, 1], [0]] ]
rede.treina(treino_xor)

puts "\n\n\nrede treinada. testando..."

xor = [0, 0]
puts rede.executa(xor)

xor = [0, 1]
puts rede.executa(xor)

xor = [1, 0]
puts rede.executa(xor)

xor = [1, 1]
puts rede.executa(xor)

