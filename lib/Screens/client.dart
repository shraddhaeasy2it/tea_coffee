import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tea_coffee/widget/theme.dart';

// Models
class Client {
  final String id;
  final String name;
  final String contact;
  final String? address;
  final double rate;
  final int totalServed;
  final int thisMonthTotal;
  final DateTime? lastServiceDate;

  Client({
    required this.id,
    required this.name,
    required this.contact,
    this.address,
    required this.rate,
    required this.totalServed,
    required this.thisMonthTotal,
    this.lastServiceDate,
  });
}

// Main Client List Screen
class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final List<Client> _clients = [
    Client(
      id: '1',
      name: 'John Doe',
      contact: '+1 234-567-8900',
      address: '123 Main St, City',
      rate: 50.0,
      totalServed: 125,
      thisMonthTotal: 8,
      lastServiceDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Client(
      id: '2',
      name: 'Jane Smith',
      contact: 'jane@example.com',
      address: '456 Oak Ave, Town',
      rate: 65.0,
      totalServed: 89,
      thisMonthTotal: 6,
      lastServiceDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Client(
      id: '3',
      name: 'Robert Johnson',
      contact: '+1 987-654-3210',
      address: '789 Pine Rd, Village',
      rate: 45.0,
      totalServed: 156,
      thisMonthTotal: 12,
      lastServiceDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _addClient(Client client) {
    setState(() {
      _clients.add(client);
    });
  }

  void _updateClient(Client updatedClient) {
    setState(() {
      final index = _clients.indexWhere((c) => c.id == updatedClient.id);
      if (index != -1) {
        _clients[index] = updatedClient;
      }
    });
  }

  void _navigateToAddClient() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ClientFormBottomSheet(onSave: _addClient),
    );
  }

  // void _navigateToClientDetail(Client client) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ClientDetailScreen(client: client),
  //     ),
  //   );
  // }

  void _editClient(Client client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          ClientFormBottomSheet(client: client, onSave: _updateClient),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clients Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddClient,
          ),
        ],
      ),
      body: Container(
        color: appTheme.scaffoldBackgroundColor,
        child: ListView.builder(
          itemCount: _clients.length,
          itemBuilder: (context, index) {
            final client = _clients[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              color: appTheme.colorScheme.primaryContainer,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: appTheme.colorScheme.tertiary,
                  child: Text(
                    client.name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  client.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: appTheme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      client.contact,
                      style: TextStyle(
                        color: appTheme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatTile(
                          'Total',
                          '${client.totalServed}',
                          Icons.people,
                        ),
                        _buildStatTile(
                          'This Month',
                          '${client.thisMonthTotal}',
                          Icons.calendar_month,
                        ),
                        _buildStatTile(
                          'Rate',
                          '\$${client.rate.toStringAsFixed(2)}',
                          Icons.attach_money,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: appTheme.colorScheme.onSurface,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editClient(client);
                    } else if (value == 'delete') {
                      _showDeleteDialog(client);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
                //onTap: () => _navigateToClientDetail(client),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: appTheme.colorScheme.tertiary),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appTheme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: appTheme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: Text('Are you sure you want to delete ${client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: appTheme.colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle delete logic here
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Add/Edit Client Screen
class AddEditClientScreen extends StatefulWidget {
  final Client? client;

  const AddEditClientScreen({super.key, this.client});

  @override
  State<AddEditClientScreen> createState() => _AddEditClientScreenState();
}

class _AddEditClientScreenState extends State<AddEditClientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _contactController = TextEditingController(
      text: widget.client?.contact ?? '',
    );
    _addressController = TextEditingController(
      text: widget.client?.address ?? '',
    );
    _rateController = TextEditingController(
      text: widget.client?.rate.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      // Save logic here
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null ? 'Add Client' : 'Edit Client'),
        backgroundColor: appTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: appTheme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  elevation: 2,
                  color: appTheme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _contactController,
                          label: 'Contact',
                          icon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact information';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                          icon: Icons.location_on,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _rateController,
                          label: 'Rate (\$)',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a rate';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveClient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.client == null ? 'Add Client' : 'Update Client',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: appTheme.colorScheme.onSurface),
        prefixIcon: Icon(icon, color: appTheme.colorScheme.tertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appTheme.colorScheme.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appTheme.colorScheme.primary),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: appTheme.colorScheme.onSurface),
    );
  }
}

// Client Form Bottom Sheet
class ClientFormBottomSheet extends StatefulWidget {
  final Client? client;
  final Function(Client) onSave;

  const ClientFormBottomSheet({super.key, this.client, required this.onSave});

  @override
  State<ClientFormBottomSheet> createState() => _ClientFormBottomSheetState();
}

class _ClientFormBottomSheetState extends State<ClientFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _contactController = TextEditingController(
      text: widget.client?.contact ?? '',
    );
    _addressController = TextEditingController(
      text: widget.client?.address ?? '',
    );
    _rateController = TextEditingController(
      text: widget.client?.rate.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final client = Client(
        id:
            widget.client?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        contact: _contactController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        rate: double.parse(_rateController.text),
        totalServed: widget.client?.totalServed ?? 0,
        thisMonthTotal: widget.client?.thisMonthTotal ?? 0,
        lastServiceDate: widget.client?.lastServiceDate,
      );
      widget.onSave(client);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor, // Your background color
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.client == null ? 'Add Client' : 'Edit Client',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appTheme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _contactController,
                    label: 'Contact',
                    icon: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter contact information';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.location_on,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _rateController,
                    label: 'Rate (\$)',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rate';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveClient,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.client == null ? 'Add Client' : 'Update Client',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: appTheme.colorScheme.onSurface),
        prefixIcon: Icon(icon, color: appTheme.colorScheme.tertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appTheme.colorScheme.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appTheme.colorScheme.primary),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: appTheme.colorScheme.onSurface),
    );
  }
}

// Client Detail Screen
class ClientDetailScreen extends StatelessWidget {
  final Client client;

  const ClientDetailScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(client.name),
          backgroundColor: appTheme.primaryColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: appTheme.colorScheme.secondary,
            tabs: const [
              Tab(text: 'Summary'),
              Tab(text: 'Invoices'),
              Tab(text: 'Consumption'),
            ],
          ),
        ),
        body: Container(
          color: appTheme.scaffoldBackgroundColor,
          child: TabBarView(
            children: [
              _buildMonthlySummary(),
              _buildInvoicesList(),
              _buildConsumptionGraph(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlySummary() {
    final monthlyData = [
      {'month': 'Jan', 'services': 8, 'revenue': 400},
      {'month': 'Feb', 'services': 6, 'revenue': 300},
      {'month': 'Mar', 'services': 10, 'revenue': 500},
      {'month': 'Apr', 'services': 7, 'revenue': 350},
      {'month': 'May', 'services': 9, 'revenue': 450},
      {'month': 'Jun', 'services': 12, 'revenue': 600},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: appTheme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: appTheme.colorScheme.tertiary,
                    ),
                    title: Text(
                      client.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: appTheme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      client.contact,
                      style: TextStyle(
                        color: appTheme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: appTheme.colorScheme.tertiary,
                    ),
                    title: Text(
                      client.address ?? 'No address provided',
                      style: TextStyle(color: appTheme.colorScheme.onSurface),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: appTheme.colorScheme.tertiary,
                    ),
                    title: Text(
                      'Rate: \$${client.rate.toStringAsFixed(2)} per service',
                      style: TextStyle(color: appTheme.colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Monthly Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appTheme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...monthlyData.map((data) => _buildMonthCard(data)).toList(),
        ],
      ),
    );
  }

  Widget _buildMonthCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: appTheme.colorScheme.primaryContainer,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        leading: CircleAvatar(
          backgroundColor: appTheme.colorScheme.surface,
          child: Text(
            data['month'],
            style: TextStyle(
              color: appTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${data['services']} Services',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: appTheme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Revenue: \$${data['revenue']}',
          style: TextStyle(
            color: appTheme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Text(
          '\$${(data['revenue'] / data['services']).toStringAsFixed(2)}/service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appTheme.colorScheme.tertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildInvoicesList() {
    final invoices = [
      {
        'id': 'INV-001',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'amount': 250.0,
        'status': 'Paid',
      },
      {
        'id': 'INV-002',
        'date': DateTime.now().subtract(const Duration(days: 40)),
        'amount': 300.0,
        'status': 'Paid',
      },
      {
        'id': 'INV-003',
        'date': DateTime.now().subtract(const Duration(days: 70)),
        'amount': 200.0,
        'status': 'Paid',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: appTheme.colorScheme.primaryContainer,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),

            title: Text(
              'Invoice ${invoice['id']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  DateFormat(
                    'MMM dd, yyyy',
                  ).format(invoice['date'] as DateTime),
                  style: TextStyle(
                    color: appTheme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Chip(
                  label: Text(
                    invoice['status'].toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: appTheme.colorScheme.tertiary,
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${invoice['amount']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appTheme.colorScheme.primary,
                  ),
                ),
                Text(
                  '${((invoice['amount'] as num).toDouble() / client.rate).toInt()} services',
                  style: TextStyle(
                    fontSize: 12,
                    color: appTheme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConsumptionGraph() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services Consumption Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appTheme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last 6 Months',
            style: TextStyle(
              color: appTheme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 24),
          Card(
            color: appTheme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatItem(
                    'Average Monthly Services',
                    '${(client.totalServed / 6).toStringAsFixed(1)}',
                    Icons.trending_up,
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Total Revenue',
                    '\$${(client.totalServed * client.rate).toStringAsFixed(2)}',
                    Icons.attach_money,
                  ),
                  const Divider(),
                  _buildStatItem(
                    'Last Service',
                    DateFormat(
                      'MMM dd, yyyy',
                    ).format(client.lastServiceDate ?? DateTime.now()),
                    Icons.calendar_today,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: appTheme.colorScheme.tertiary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: appTheme.colorScheme.onSurface),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appTheme.colorScheme.primary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
