//
//  ColorMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

/* saber qual modo o usuario escolheu
 - manulmente : color picker
 - automaticamente: vision
 
 dados precisam ir para:
  - faceAnalyzerService
  - ManualColorPickerService
 
 independente do arquivo, vai passar pelo PixelColorConversion
 dados convertidos, vão de um vetor de pontos para cores
 agora com vetor tendo a cor da pele, olhos e cabelo do usuario
 
 criar escopo que possui a logica para saber com qual das paletas o usuario tem compatibilidade
 */

/*
 Estação - Temperatura - Profundidade - Saturação - Característica Dominante

 Primavera Claro: Quente, Clara, Média, Luminosidade

 Primavera Quente: Quente, Média, Alta, Calor intenso

 Primavera Brilhante: Quente, Média, Muito Alta, Vibração

 Verão Claro: Frio, Clara, Baixa, Suavidade clara

 Verão Frio: Frio, Média, Baixa, Frieza intensa

 Verão Suave: Frio, Média, Muito Baixa, Neutralidade suave

 Outono Suave: Quente, Média, Baixa, Calor suavizado

 Outono Quente: Quente, Média-Escura, Média, Calor profundo

 Outono Escuro: Quente, Escura, Média, Profundidade

 Inverno Brilhante: Frio, Média, Muito Alta, Contraste vibrante

 Inverno Frio: Frio, Média-Escura, Alta, Frieza profunda

 Inverno Escuro: Frio, Escura, Alta, Dramaticidade
 */

