// Código escrito em Godot Shading Language (a linguagem de shaders do Godot), que é fortemente baseada
// em GLSL (OpenGL Shading Language)

shader_type canvas_item; // Informa ao Godot que este é um shader do tipo canvas_item

uniform float lod: hint_range(0.0, 1.0) = 0.0; // Cria uma variável que você consegue controlar diretamente
// pelo Inspector do Godot (ou via script, quando o jogo é pausado)

// hont_range cria um controle deslizante (slider) no editor que vai de 0.0 (sem efeito) até 1.0 (efeito máximo)

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap; // "fotografa" tudo o que está
// desenhado na tela atrás do nó onde o shader está aplicado

// Função executada para cada pixel individual que a imagem ou retângulo do menu ocupa na tela
// Tudo o que acontece aqui define a cor final de cada pixel.
void fragment(){
	// Pega a cor da tela (SCREEN_TEXTURE) na posição atual do pixel (SCREEN_UV) e aplica o desfoque baseado no valor lod
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	// Define que a cor final daquele pixel na tela será essa cor que acabamos de amostrar e embaçar
	COLOR = color;
}