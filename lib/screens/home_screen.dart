import 'package:flutter/material.dart';
import '../widgets/atm_card.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<AtmCard> cards = [
    AtmCard(
      bankName: 'Bank BNI',
      cardNumber: '1234 5678 9012 3456',
      cardHolder: 'Selly Oktapaeni',
      balance: 'Rp 12.500.000',
      gradientColors: [Colors.teal, Colors.tealAccent],
    ),
    AtmCard(
      bankName: 'Bank BRI',
      cardNumber: '9876 5432 1098 7654',
      cardHolder: 'Selly Oktapaeni',
      balance: 'Rp 8.750.000',
      gradientColors: [
        const Color.fromARGB(255, 117, 171, 210),
        const Color(0xFF9AD6E4),
      ],
    ),
    AtmCard(
      bankName: 'Bank Mandiri',
      cardNumber: '4567 1234 8901 2345',
      cardHolder: 'Selly Oktapaeni',
      balance: 'Rp 5.250.000',
      gradientColors: [
        const Color.fromARGB(255, 48, 145, 100),
        const Color.fromARGB(255, 40, 118, 43),
      ],
    ),
  ];

  final transactions = [
    TransactionModel('Belanja Tokopedia', '-Rp 250.000', 'Belanja Online'),
    TransactionModel('Transfer ke Dinda', '-Rp 500.000', 'Transfer'),
    TransactionModel('Gaji Bulanan', '+Rp 5.000.000', 'Pemasukan'),
    TransactionModel('Top Up Gopay', '-Rp 100.000', 'Dompet Digital'),
    TransactionModel('Coffeeshop', '-Rp 35.000', 'Konsumsi'),
  ];

  @override
  void initState() {
    super.initState();
    _autoScroll(); // panggil fungsi auto scroll
  }

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= cards.length) _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _autoScroll(); // loop
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FinanceMate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Cards',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Carousel Cards
            SizedBox(
              height: 210,
              child: PageView.builder(
                controller: _pageController,
                itemCount: cards.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = index.toDouble() - (_pageController.page ?? 0);
                        value = (1 - (value.abs() * 0.25)).clamp(0.85, 1.0);
                      }
                      return Transform.scale(
                        scale: value,
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: cards[index],
                  );
                },
              ),
            ),

            const SizedBox(height: 28),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: const [
                _ActionButton(icon: Icons.send, label: 'Transfer'),
                _ActionButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Top Up',
                ),
                _ActionButton(icon: Icons.payment, label: 'Pay'),
                _ActionButton(icon: Icons.history, label: 'History'),
              ],
            ),

            const SizedBox(height: 28),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: transactions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    TransactionItem(transaction: transactions[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal.withOpacity(0.15),
          radius: 25,
          child: Icon(icon, color: Colors.teal, size: 26),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
