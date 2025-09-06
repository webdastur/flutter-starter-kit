import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/hooks/app_hooks.dart';

/// Demo page showing flutter_hooks usage examples
class HooksDemoPage extends HookWidget {
  const HooksDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic hooks examples
    final counter = useState(0);
    final textController = useTextEditingController();
    final animationController = useAnimationController(
      duration: const Duration(seconds: 1),
    );

    // Custom hook example
    final searchController = useSearch();

    // Async operation example
    final asyncOp = useAsyncOperation(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Operation completed!';
    });

    // Effect for animation
    useEffect(() {
      animationController.repeat(reverse: true);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Hooks Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Counter example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'useState Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Count: ${counter.value}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => counter.value--,
                          child: const Text('-'),
                        ),
                        ElevatedButton(
                          onPressed: () => counter.value++,
                          child: const Text('+'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Custom Hook Example (Search with Debouncing)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController.controller,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: const OutlineInputBorder(),
                        suffixIcon: searchController.query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: searchController.clear,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Current query: "${searchController.query}"'),
                    Text(
                      'Debounced query: "${searchController.debouncedQuery}"',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Animation example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'useAnimationController Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.5 + (animationController.value * 0.5),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.lerp(
                                Colors.blue,
                                Colors.red,
                                animationController.value,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Async operation example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'useAsyncOperation Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (asyncOp.isLoading)
                      const CircularProgressIndicator()
                    else if (asyncOp.error != null)
                      Text(
                        'Error: ${asyncOp.error}',
                        style: const TextStyle(color: Colors.red),
                      )
                    else if (asyncOp.data != null)
                      Text(
                        asyncOp.data!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: asyncOp.isLoading ? null : asyncOp.execute,
                          child: const Text('Execute'),
                        ),
                        ElevatedButton(
                          onPressed: asyncOp.reset,
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Form example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'useTextEditingController Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('You typed: "${textController.text}"'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
