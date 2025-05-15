/// A Flutter widget that renders tabbed navigation for form sections
/// based on a Form.io "tabs" component.
///
/// Each tab can contain one or more form components. Tabs are switched
/// dynamically and data for each tab is tracked independently.

import 'package:flutter/material.dart';

import '../../models/component.dart';
import '../component_factory.dart';

class TabsComponent extends StatefulWidget {
  /// The Form.io component definition for the tabs.
  final ComponentModel component;

  /// Form value map for all child components across tabs.
  final Map<String, dynamic> value;

  /// Callback triggered when any child component's value changes.
  final ValueChanged<Map<String, dynamic>> onChanged;

  const TabsComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  @override
  State<TabsComponent> createState() => _TabsComponentState();
}

class _TabsComponentState extends State<TabsComponent> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<dynamic> _tabsRaw;
  late List<String> _tabLabels;

  @override
  void initState() {
    super.initState();
    _tabsRaw = widget.component.raw['components'] as List? ?? [];
    _tabLabels = _tabsRaw.map((tab) => tab['label']?.toString() ?? 'Tab').toList();
    _tabController = TabController(length: _tabsRaw.length, vsync: this);
  }

  List<ComponentModel> _getTabComponents(int index) {
    final components = _tabsRaw[index]['components'] as List? ?? [];
    return components.map((c) => ComponentModel.fromJson(c)).toList();
  }

  void _updateField(String key, dynamic newValue) {
    final updated = Map<String, dynamic>.from(widget.value);
    updated[key] = newValue;
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    if (_tabsRaw.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 400, // fixed height; can be adapted
          child: TabBarView(
            controller: _tabController,
            children: List.generate(_tabsRaw.length, (index) {
              final components = _getTabComponents(index);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children:
                      components
                          .map(
                            (comp) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: ComponentFactory.build(component: comp, value: widget.value[comp.key], onChanged: (val) => _updateField(comp.key, val)),
                            ),
                          )
                          .toList(),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
