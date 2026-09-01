import 'package:flutter/material.dart';

// Importa los componentes visuales y las herramientas principales de Flutter.

void main() {
  runApp(const CalculadoraApp());
}

// Punto de entrada de la aplicación: inicia el widget principal.
class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      // Nombre que identifica la aplicación en Flutter.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // Tema global basado en un color semilla y en Material 3.
      ),
      home: const CalculadoraScreen(),
      // Pantalla que se muestra al abrir la aplicación.
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  // Crea el objeto que conservará y actualizará el estado de la pantalla.
  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String display = '0';
  String operacion = '';
  double numeroAnterior = 0;
  bool novoNumero = true;

  // Texto que aparece en la pantalla de la calculadora.
  void _presionarNumero(String numero) {
    setState(() {
      if (novoNumero) {
        display = numero;
        novoNumero = false;
      } else {
        // Evita conservar el cero inicial al escribir un número.
        display = display == '0' ? numero : display + numero;
      }
    });
  }

  // Guarda el operador seleccionado y el primer número de la operación.
  void _presionarOperacion(String op) {
    setState(() {
      numeroAnterior = double.parse(display);
      operacion = op;
      novoNumero = true;
    });
  }

  // Ejecuta la operación pendiente usando el número mostrado actualmente.
  void _calcular() {
    setState(() {
      double numeroActual = double.parse(display);
      double resultado = 0;

      switch (operacion) {
        case '+':
          resultado = numeroAnterior + numeroActual;
          break;
        case '-':
          resultado = numeroAnterior - numeroActual;
          break;
        case '*':
          resultado = numeroAnterior * numeroActual;
          break;
        case '/':
          resultado = numeroAnterior / numeroActual;
          break;
      }

      // Muestra hasta dos decimales y elimina ceros innecesarios al final.
      display = resultado.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
      operacion = '';
      novoNumero = true;
    });
  }

  // Restablece todos los valores de la calculadora a su estado inicial.
  void _limpiar() {
    setState(() {
      display = '0';
      operacion = '';
      numeroAnterior = 0;
      novoNumero = true;
    });
  }

  // Elimina el último carácter del número mostrado.
  void _borrar() {
    setState(() {
      if (display.length > 1) {
        display = display.substring(0, display.length - 1);
      } else {
        display = '0';
      }
    });
  }

  // Añade el separador decimal si el número todavía no contiene uno.
  void _agregarPunto() {
    setState(() {
      if (!display.contains('.')) {
        display = '$display.';
        novoNumero = false;
      }
    });
  }

  // Construye un botón reutilizable con tamaño, color y acción configurables.
  Widget _crearBoton(
    String texto,
    VoidCallback onPressed, {
    Color? color,
    double? fontSize,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[700],
            padding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            texto,
            style: TextStyle(
              fontSize: fontSize ?? 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora'), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.all(24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _limpiar,
                            child: const Text(
                              'C',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.all(24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _borrar,
                            child: const Icon(
                              Icons.backspace_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      _crearBoton(
                        '÷',
                        () => _presionarOperacion('/'),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _crearBoton('7', () => _presionarNumero('7')),
                      _crearBoton('8', () => _presionarNumero('8')),
                      _crearBoton('9', () => _presionarNumero('9')),
                      _crearBoton(
                        '×',
                        () => _presionarOperacion('*'),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _crearBoton('4', () => _presionarNumero('4')),
                      _crearBoton('5', () => _presionarNumero('5')),
                      _crearBoton('6', () => _presionarNumero('6')),
                      _crearBoton(
                        '−',
                        () => _presionarOperacion('-'),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _crearBoton('1', () => _presionarNumero('1')),
                      _crearBoton('2', () => _presionarNumero('2')),
                      _crearBoton('3', () => _presionarNumero('3')),
                      _crearBoton(
                        '+',
                        () => _presionarOperacion('+'),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              padding: const EdgeInsets.all(24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _presionarNumero('0'),
                            child: const Text(
                              '0',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _crearBoton('.', _agregarPunto),
                      _crearBoton('=', _calcular, color: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
