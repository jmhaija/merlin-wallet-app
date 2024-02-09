class ModelClass {
  String _modelState = 'prestine';
  String? _resourceID;
  String? _collectionURI;
  Map<String, dynamic> _resource = {};

  void generateInstance(Map<String, dynamic> resourceRepresentation) {
    _resource = resourceRepresentation;
    if(_resource.isNotEmpty) {
      resourceRepresentation.forEach((key, value) {
        if(_resource.containsKey(key)){
          _resource[key] = value;
        }
      });
    }
    _modelState = 'initialized';
  }

  Map<String, dynamic> getResource() {
    return _resource;
  }
  void setCollectionURI(String uri) {
    _collectionURI = uri;
  }

  String getCollectionURI() {
    return _collectionURI!;
  }
  

  String getResourceURI() {
      if (_resourceID == null) {
      throw 'Cannot have a resource URI without a resource ID';
    }
    return '${getCollectionURI()}/${getResourceID()}';
  }


  void setResourceID(String id) {
    _resourceID = id;
    _setState('identified');
  }

  String getResourceID() {
    return _resourceID!;
  }

  void _setState(String state) {
    if(_resourceID != null) {
      _modelState = state;
    }
  } 

  String getState() {
    return _modelState;
  }

  void clearInstance() {
    _resource.forEach((key, value) {
      _resource.remove(key);
    });

    _modelState = 'prestine';
  }

  void appendResource(Map<String, dynamic> data){
    _resource.addAll(data);
  }
}
