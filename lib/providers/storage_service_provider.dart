

import 'dart:io';
import 'dart:typed_data';

import 'package:client_app/utils/globals.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class StorageServiceProvier{
	// Create a storage reference from our app
	static final storageRef = FirebaseStorage.instance.ref();
	
	Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

	String generateFileName() {
		return [ sharedPreferences.getString('user_id'), DateTime.now().millisecondsSinceEpoch].join('-');
	}

	Future<String> uploadFile(file, directory) async {
		final imagesRef = storageRef.child(directory);
		final childImageRef = imagesRef.child(generateFileName()); // how to get image with filename
		String filePath = childImageRef.fullPath;
		try {
			await childImageRef.putFile(file);
		} on FirebaseException  {
			// ...
		}
		return filePath;
	}

	Future<void> removeFile(filePath) async {
		var fileRef = storageRef.child(filePath);
		await fileRef.delete();
	}

	Future<dynamic> retrieveFile(filePath) async {
		String gsPath = globalSettings['firebase']['storage']['url'] + '/' +  filePath;
		final gsReference = FirebaseStorage.instance.refFromURL(gsPath);
		Uint8List? data;
		try{
			data = await gsReference.getData();
		} on Exception {
			throw 'Cannot retrieve the data with the given path from firebase storage';
		}
		if(data != null){
			var buffer = data.buffer;
			String byteFilePath = '${await _localPath}/${filePath.split('/')[1]}';
			var bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
			//store retrieved file from cloud storage to local filesystem as a byte file
			File file = await File(byteFilePath).writeAsBytes(bytes);	
			return file;
		}
		return null;
	}
}