import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'telas/tela_entrada_cores.dart';
import 'telas/tela_paleta.dart';
import 'telas/tela_detalhes_cor.dart';

void main() {
  runApp(MeuAppGeradorCoresModerno());
}

class MeuAppGeradorCoresModerno extends StatelessWidget {
  const MeuAppGeradorCoresModerno({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme); // Escolha uma fonte

    return MaterialApp(
      title: 'Gerador de Paleta Moderno',
      theme: ThemeData(
        // --- Esquema de Cores ---
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Cor base para gerar a paleta do tema
          brightness: Brightness.light,
          background: Colors.grey[50], // Fundo levemente cinza
          surface: Colors.white, // Cor de Cards, Dialogs, etc.
        ),

        // --- Tipografia ---
        textTheme: baseTextTheme.copyWith(
           // Ajustar estilos específicos se necessário
           headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
           bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16.0),
        ),

        // --- Tema da AppBar ---
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Transparente para ver o fundo
          elevation: 0, // Sem sombra
          foregroundColor: Colors.grey[800], // Cor dos ícones/texto da AppBar
           titleTextStyle: baseTextTheme.titleLarge?.copyWith(color: Colors.grey[800], fontWeight: FontWeight.w600),
           iconTheme: IconThemeData(color: Colors.grey[800]), // Cor do ícone de voltar
        ),

        // --- Tema dos Botões Elevados ---
         elevatedButtonTheme: ElevatedButtonThemeData(
           style: ElevatedButton.styleFrom(
             foregroundColor: Colors.white, // Cor do texto/ícone do botão
             backgroundColor: Colors.teal, // Cor de fundo do botão
             padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12.0), // Cantos arredondados
             ),
             textStyle: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
           ),
         ),

         // --- Tema dos Campos de Texto ---
         inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[200], // Cor de preenchimento
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none, // Sem borda visível
            ),
            enabledBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(12.0),
               borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(12.0),
               borderSide: BorderSide(color: Colors.teal, width: 1.5), // Borda ao focar
            ),
            hintStyle: baseTextTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
             labelStyle: baseTextTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
             prefixIconColor: Colors.grey[600],
         ),

         // --- Tema dos Cards ---
         cardTheme: CardTheme(
           elevation: 2.0, // Sombra sutil padrão
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12.0), // Cantos arredondados padrão
           ),
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0), // Margem padrão
         ),

        useMaterial3: true, // Habilitar Material 3 (influencia visuais)
      ),
      routes: {
        '/': (context) => TelaEntradaCores(),
        '/paleta': (context) => TelaPaleta(),
        '/detalhes': (context) => TelaDetalhesCor(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}