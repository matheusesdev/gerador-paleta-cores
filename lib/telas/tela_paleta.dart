import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback e Clipboard
import 'package:flutter_animate/flutter_animate.dart'; // Para animações

// Mover função auxiliar para fora ou para um arquivo de utilidades
String colorToHexString(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

class TelaPaleta extends StatelessWidget {
  const TelaPaleta({Key? key}) : super(key: key);

  // Manter a lista de cores e o máximo
  static const int maximoCoresDisponiveis = 17;
  final List<Color> _listaDeCoresBase = const [
     Colors.blueAccent, Colors.redAccent, Colors.greenAccent, Colors.orangeAccent,
     Colors.purpleAccent, Colors.pinkAccent, Colors.teal, Colors.cyan,
     Colors.amberAccent, Colors.indigo, Colors.lime, Colors.brown, Colors.grey,
     Colors.lightBlue, Colors.deepOrangeAccent, Colors.yellow, Colors.black,
  ];

  void _copiarParaClipboard(BuildContext context, String text, String tipo) {
     Clipboard.setData(ClipboardData(text: text)).then((_) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$tipo "$text" copiado!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          margin: const EdgeInsets.all(10.0),
          duration: const Duration(seconds: 2),
        ));
     });
  }

  @override
  Widget build(BuildContext context) {
    final Object? argumento = ModalRoute.of(context)?.settings.arguments;
    final int numeroCores = (argumento is int && argumento >= 1 && argumento <= maximoCoresDisponiveis)
                            ? argumento : 1;

    final textTheme = Theme.of(context).textTheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar( // AppBar sutil
        title: Text('Sua Paleta ($numeroCores)'),
        // backgroundColor já é transparente pelo tema
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Título da seção
              Text(
                'Toque na cor para detalhes ou copie o Hex:',
                style: textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 15.0),

              // GridView para as cores
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 colunas (ajuste conforme necessário)
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.5, // Proporção Largura/Altura do Card
                  ),
                  itemCount: numeroCores,
                  itemBuilder: (context, index) {
                    final Color corAtual = _listaDeCoresBase[index % _listaDeCoresBase.length];
                    final String hex = colorToHexString(corAtual);
                    // Tag única para a animação Hero
                    final String heroTag = 'color-${corAtual.value}-$index';

                    // Widget do item da grade (Card)
                    return _ColorGridItem(
                       color: corAtual,
                       hex: hex,
                       heroTag: heroTag,
                       index: index,
                       onCopyTap: () => _copiarParaClipboard(context, hex, 'Hex'),
                       onCardTap: () {
                         HapticFeedback.lightImpact();
                         Navigator.pushNamed(
                           context,
                           '/detalhes',
                           arguments: {'color': corAtual, 'heroTag': heroTag}, // Passa cor e tag
                         );
                       },
                    ).animate() // Anima cada item da grade
                     .fadeIn(delay: (100 * (index * 0.5)).ms, duration: 400.ms)
                     .slideY(begin: 0.2, delay: (100 * (index * 0.5)).ms, duration: 400.ms);
                  },
                ),
              ),
              const SizedBox(height: 15.0),

              // Botão Voltar (se necessário, pode usar apenas o da AppBar)
              // ElevatedButton(
              //   onPressed: () => Navigator.pop(context),
              //   child: const Text('Voltar'),
              //   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]),
              // ).animate().fadeIn(delay: 500.ms), // Animar se adicionado
            ],
          ),
        ),
      ),
    );
  }
}

// --- Widget auxiliar para o Item da Grade ---
class _ColorGridItem extends StatelessWidget {
  final Color color;
  final String hex;
  final String heroTag;
  final int index;
  final VoidCallback onCopyTap;
  final VoidCallback onCardTap;

  const _ColorGridItem({
    required this.color,
    required this.hex,
    required this.heroTag,
    required this.index,
    required this.onCopyTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
     final bool isDarkColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
     final Color textColor = isDarkColor ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.8);
     final Color iconColor = isDarkColor ? Colors.white70 : Colors.black54;

    return Card( // Usa o CardTheme definido no main.dart
       clipBehavior: Clip.antiAlias, // Garante que o InkWell fique dentro das bordas
       child: InkWell(
         onTap: onCardTap,
         splashColor: textColor.withOpacity(0.2),
         child: Hero( // Envolve o conteúdo visual com Hero
           tag: heroTag,
           child: Stack(
             fit: StackFit.expand,
             children: [
               // Fundo colorido
               Container(color: color),

               // Informações sobrepostas
               Positioned(
                 bottom: 8,
                 left: 10,
                 child: Text(
                   hex,
                   style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [Shadow(blurRadius: 1, color: Colors.black.withOpacity(isDarkColor ? 0.5 : 0.2))]
                    ),
                 ),
               ),
               Positioned(
                 top: 4,
                 right: 4,
                 child: IconButton(
                    icon: Icon(Icons.copy_outlined, size: 20, color: iconColor),
                    tooltip: 'Copiar Hex',
                    visualDensity: VisualDensity.compact, // Ícone menor
                    onPressed: onCopyTap,
                 ),
               ),
             ],
           ),
         ),
       ),
    );
  }
}