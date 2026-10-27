import 'dart:async';

// ----------------------------------------------------------------------------
// ABSTRACT CLASS / INTERFACE
// What it does: Defines an interface contract forcing subclasses to implement maintenance.
// Why built this way: Ensures that all transport vehicles in the fleet maintain 
// a unified maintenance standard, promoting scalability and standard API design.
// ----------------------------------------------------------------------------
abstract class Maintainable {
  Future<void> performMaintenance();
}

// ----------------------------------------------------------------------------
// MIXIN
// What it does: Adds reusable air conditioning capabilities without inheritance.
// Why built this way: Demonstrates composition over inheritance—allowing optional 
// features like climate control to be added only to vehicle types that support it.
// ----------------------------------------------------------------------------
mixin AirConditioned {
  bool isACOn = false;

  void toggleAC() {
    isACOn = !isACOn;
    print('   [AC SYSTEM] Climate control turned ${isACOn ? "ON ❄️" : "OFF 🛑"}.');
  }
}

// ----------------------------------------------------------------------------
// BASE CLASS
// What it does: Models core Jeepney properties, encapsulation, and fare logic.
// Why built this way: Serves as the fundamental parent class in our object hierarchy,
// holding shared properties (route, capacity) while protecting sensitive financial 
// state (_collectedFare) via getter/setter encapsulation.
// ----------------------------------------------------------------------------
class Jeepney implements Maintainable {
  // Public fields defining vehicle state
  String plateNumber;
  String route;
  int capacity;
  int currentPassengers;

  // Encapsulated private property (starts with '_')
  // Protects financial data from unauthorized direct external mutation.
  double _collectedFare = 0.0;

  // --------------------------------------------------------------------------
  // CONSTRUCTOR
  // What it does: Initializes a Jeepney instance with required and default values.
  // Why built this way: Enforces strict data initialization rules so every jeepney 
  // created has valid route and seating configuration before operation begins.
  // --------------------------------------------------------------------------
  Jeepney({
    required this.plateNumber,
    required this.route,
    required this.capacity,
    this.currentPassengers = 0,
  });

  // Getter for safe reading of encapsulated field
  double get totalFare => _collectedFare;

  // --------------------------------------------------------------------------
  // METHOD: collectFare
  // What it does: Validates and updates the total fare collected.
  // Why built this way: Encapsulation barrier ensuring negative or invalid 
  // amounts cannot corrupt revenue accounting data.
  // --------------------------------------------------------------------------
  void collectFare(double amount) {
    if (amount > 0) {
      _collectedFare += amount;
    } else {
      print('   [WARNING] Invalid fare amount specified.');
    }
  }

  // --------------------------------------------------------------------------
  // METHOD: honk (Virtual method for Polymorphism)
  // What it does: Plays a standard horn notification.
  // Why built this way: Provides a default behavior meant to be overridden 
  // by derived classes to demonstrate polymorphic execution.
  // --------------------------------------------------------------------------
  void honk() {
    print('   [$plateNumber] Standard Horn: Beep beep!');
  }

  // --------------------------------------------------------------------------
  // METHOD: performMaintenance (Abstract implementation)
  // What it does: Performs baseline vehicle inspection.
  // Why built this way: Fulfills the abstract contract established by Maintainable.
  // --------------------------------------------------------------------------
  @override
  Future<void> performMaintenance() async {
    print('   [$plateNumber] Performing general safety inspection for route: $route...');
  }

  // --------------------------------------------------------------------------
  // ASYNC METHOD: syncTripData
  // What it does: Simulates sending vehicle telemetry and fare data to a remote cloud server.
  // Why built this way: Demonstrates asynchronous non-blocking logic using Future.delayed 
  // to mirror real-world mobile app interaction with REST APIs or cloud databases.
  // --------------------------------------------------------------------------
  Future<String> syncTripData() async {
    print('   [ASYNC INIT] Connecting to cloud endpoint for vehicle $plateNumber...');
    // Simulate network delay (2 seconds)
    await Future.delayed(Duration(seconds: 2));
    return '   [ASYNC COMPLETE] Successfully uploaded ₱${_collectedFare.toStringAsFixed(2)} revenue data for $plateNumber.';
  }
}

// ----------------------------------------------------------------------------
// DERIVED CLASS 1: TraditionalJeepney
// What it does: Extends base Jeepney for traditional diesel models.
// Why built this way: Implements specific domain rules and overrides behaviors 
// unique to traditional public utility vehicles (PUVs).
// ----------------------------------------------------------------------------
class TraditionalJeepney extends Jeepney {
  TraditionalJeepney({
    required String plateNumber,
    required String route,
    required int capacity,
  }) : super(plateNumber: plateNumber, route: route, capacity: capacity);

  // Overriding method to show Polymorphism
  @override
  void honk() {
    print('   [$plateNumber] Traditional Horn: AHOOGA! Loud air horn!');
  }

  @override
  Future<void> performMaintenance() async {
    print('   [$plateNumber] Traditional Service: Inspecting diesel engine, clutch, and tires...');
    await Future.delayed(Duration(milliseconds: 500));
    print('   [$plateNumber] Maintenance complete.');
  }
}

// ----------------------------------------------------------------------------
// DERIVED CLASS 2: ModernJeepney
// What it does: Extends Jeepney and injects AirConditioned mixin for modern e-jeeps.
// Why built this way: Combines class inheritance with mixin composition to 
// create specialized modern transit vehicles equipped with climate control and GPS.
// ----------------------------------------------------------------------------
class ModernJeepney extends Jeepney with AirConditioned {
  ModernJeepney({
    required String plateNumber,
    required String route,
    required int capacity,
  }) : super(plateNumber: plateNumber, route: route, capacity: capacity);

  // Overriding method to show Polymorphism
  @override
  void honk() {
    print('   [$plateNumber] Modern Horn: Soft electronic chime chime!');
  }

  @override
  Future<void> performMaintenance() async {
    print('   [$plateNumber] Modern Service: Diagnosing electric battery health and AC filter...');
    await Future.delayed(Duration(milliseconds: 500));
    print('   [$plateNumber] Maintenance complete.');
  }

  // Additional Async behavior unique to ModernJeepney
  Future<String> fetchGPSLocation() async {
    print('   [ASYNC INIT] Querying GPS satellites for vehicle $plateNumber...');
    await Future.delayed(Duration(seconds: 1));
    return '   [LOCATION RETURNED] $plateNumber is currently active along $route.';
  }
}

// ----------------------------------------------------------------------------
// MAIN ENTRY POINT
// What it does: Executes the complete program demonstrating all OOP, collection, 
// and asynchronous workflows.
// Why built this way: Marked 'async' to allow execution of asynchronous Futures 
// sequentially while verifying non-blocking user experience patterns.
// ----------------------------------------------------------------------------
void main() async {
  print('================================================================');
  print('     PC16 MILESTONE 2: JEEPNEY FLEET MANAGEMENT SYSTEM          ');
  print('================================================================\n');

  // 1. INSTANTIATION & OBJECT CREATION
  TraditionalJeepney jeep1 = TraditionalJeepney(
    plateNumber: 'NTC-1918',
    route: 'Quiapo - Cubao',
    capacity: 20,
  );

  ModernJeepney jeep2 = ModernJeepney(
    plateNumber: 'E-JEEP-2026',
    route: 'EDSA - Taft',
    capacity: 24,
  );

  // 2. LIST COLLECTION
  // Stores objects polymorphically under base type reference
  List<Jeepney> fleetList = [jeep1, jeep2];

  // 3. MAP COLLECTION
  // Key-Value mapping (Plate Number -> Jeepney Instance) for O(1) lookup
  Map<String, Jeepney> fleetMap = {
    jeep1.plateNumber: jeep1,
    jeep2.plateNumber: jeep2,
  };

  // 4. DEMONSTRATING POLYMORPHISM & ENCAPSULATION
  print('--- 1. FLEET OPERATIONS & POLYMORPHISM DEMO ---');
  for (var jeep in fleetList) {
    print('Operating Vehicle: ${jeep.runtimeType} (${jeep.plateNumber})');
    jeep.honk(); // Polymorphic method invocation
    jeep.collectFare(15.0 * 10); // Encapsulated fare updates
    print('   Total Collected Fare: ₱${jeep.totalFare.toStringAsFixed(2)}');
    await jeep.performMaintenance();
    print('');
  }

  // 5. DEMONSTRATING MIXIN CAPABILITY
  print('--- 2. MIXIN & SPECIFIC FEATURE DEMO ---');
  print('Activating Modern Jeepney Aircon System:');
  jeep2.toggleAC();
  print('');

  // 6. DEMONSTRATING ASYNC / AWAIT & NON-BLOCKING BEHAVIOR
  print('--- 3. ASYNCHRONOUS DATA SYNC DEMO ---');
  print('Triggering asynchronous network transactions...');
  print('   [UI NOTICE] Main thread remains responsive during network requests...\n');

  // Querying GPS asynchronously
  String gpsStatus = await jeep2.fetchGPSLocation();
  print(gpsStatus);
  print('');

  // Batch syncing data for all vehicles in Map collection asynchronously
  print('Syncing total revenue to cloud servers across fleet:');
  for (var entry in fleetMap.entries) {
    String syncOutput = await entry.value.syncTripData();
    print(syncOutput);
  }

  print('\n================================================================');
  print('     ALL MILESTONE 2 PRACTICAL TASKS EXECUTED SUCCESSFULLY!      ');
  print('================================================================');
}