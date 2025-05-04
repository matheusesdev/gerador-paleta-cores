import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para Clipboard e HapticFeedback
import 'package:flutter_animate/flutter_animate.dart'; // Para animações

// Reutilizar a função auxiliar
String colorToHexString(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

class TelaDetalhesCor extends StatelessWidget {
  const TelaDetalhesCor({Key? key}) : super(key: key);

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
    // Recuperar argumentos (Mapa contendo cor e tag)
    final Object? routeArgs = ModalRoute.of(context)?.settings.arguments;
    Color corSelecionada = Colors.grey; // Cor padrão
    String heroTag = 'color-default'; // Tag padrão

    if (routeArgs is Map<String, dynamic>) {
       corSelecionada = routeArgs['color'] as Color? ?? Colors.grey;
       heroTag = routeArgs['heroTag'] as String? ?? 'color-default-${corSelecionada.value}';
    }

    final bool isDarkColor = ThemeData.estimateBrightnessForColor(corSelecionada) == Brightness.dark;
    final Color appBarForegroundColor = isDarkColor ? Colors.white : Colors.black87;

    // Calcular valores
    final int r = corSelecionada.red;
    final int g = corSelecionada.green;
    final int b = corSelecionada.blue;
    final String hexString = colorToHexString(corSelecionada);
    final String rgbString = '$r, $g, $b';

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true, // Permite que o corpo fique sob a AppBar transparente
      appBar: AppBar(
        // title: Text('Detalhes'), // Título opcional
        backgroundColor: Colors.transparent, // Já definido no tema
        foregroundColor: appBarForegroundColor, // Ajusta cor do ícone voltar
        elevation: 0,
        systemOverlayStyle: isDarkColor ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark, // Ajusta cor da status bar
      ),
      body: Column( // Layout principal
        children: <Widget>[
          // --- Área Superior com a Cor e Hero ---
          Expanded(
             flex: 2, // Ocupa mais espaço
             child: Hero(
               tag: heroTag, // Usa a tag recebida
               child: Container(
                 decoration: BoxDecoration(
                    color: corSelecionada,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.2),
                         blurRadius: 10.0,
                         spreadRadius: 2.0,
                         offset: const Offset(0, 4),
                       )
                    ]
                 ),
                 // Conteúdo opcional dentro do container colorido (ex: nome da cor se disponível)
               ),
             ),
          ),

          // --- Área Inferior com Detalhes ---
          Expanded(
            flex: 3, // Ocupa o restante do espaço
            child: SingleChildScrollView(
               padding: const EdgeInsets.all(25.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Text(
                      'Valores da Cor',
                      style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                    const SizedBox(height: 25),

                    // Detalhe Hex
                    _DetailRow(
                      icon: Icons.tag, // Ícone para Hex
                      label: 'Hex',
                      value: hexString,
                      onCopy: () => _copiarParaClipboard(context, hexString, 'Hex'),
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                    const SizedBox(height: 20),

                    // Detalhe RGB
                    _DetailRow(
                      icon: Icons.palette_outlined, // Ícone para RGB
                      label: 'RGB',
                      value: '($rgbString)',
                      onCopy: () => _copiarParaClipboard(context, rgbString, 'RGB'),
                    ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),

                     // Poderia adicionar outros valores aqui (HSL, CMYK se calculados)

                 ],
               ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget auxiliar para exibir uma linha de detalhe (Ícone, Label, Valor, Copiar) ---
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.labelLarge?.copyWith(color: Colors.grey[600])),
              SelectableText( // Permite seleção do valor
                 value,
                 style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace', // Fonte monoespaçada para valores
                    fontSize: 18
                 ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy_outlined),
          tooltip: 'Copiar $label',
          color: Colors.grey[500],
          onPressed: onCopy,
        ),
      ],
    );
  }
}