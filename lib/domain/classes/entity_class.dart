class EntityClass {
  String _entityState = 'prestine';
  String? _resourceID;
  String? _collectionURI;
  Map<String, dynamic> _resource = {};

  void init(Map<String, dynamic> resourceDefinition) {
    if (resourceDefinition['collectionURI'] == null || resourceDefinition['resourceMap'] == null) {
      throw Exception('collectionURI and resourceMap must be present in order to generate a class instance');
    }
    _collectionURI = resourceDefinition['collectionURI'];
    _resource = resourceDefinition;
    if (_resource.isNotEmpty) {
      _entityState = 'initialiized';
    }
  }

  void populateEntity(Map<String, dynamic> resourceRepresentation) {
    _resource = resourceRepresentation;
    if (_resource.isNotEmpty) {
      resourceRepresentation.forEach((key, value) {
        if (_resource.containsKey(key)) {
          _resource[key] = value;
        }
      });
      _entityState = 'populated';
    }
  }

  String getResourceURI(String value) {
    if (_resourceID == null) {
      throw Exception('Cannot have a resource URI without a resource ID');
    }
    return '$_collectionURI/$_resourceID';
  }

  void setResourceID(String id) {
    _resourceID = id;
  }

  String getResourceID() {
    if (_resourceID == null) {
      throw Exception('Resource ID is not initialized');
    }
    return _resourceID!;
  }

  void setState(String state) {
    if (_resourceID != null) {
      _entityState = state;
    } else {
      throw Exception('Cannot set state without a resource ID');
    }
  }

  Map<String, dynamic> getResource() {
    return _resource;
  }

  String getState() {
    return _entityState;
  }

  void clearInstance() {
    _collectionURI = null;
    _resourceID = null;
    if (_resource != {}) {
      _resource.clear();
    }
    _entityState = 'prestine';
  }
}
