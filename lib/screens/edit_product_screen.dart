import 'package:flutter/material.dart';
import 'package:shoping_app/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers/product_data.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({Key? key}) : super(key: key);
  static const routeName = '/editProduct';

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;

  var _editedProduct = Product(
    id: 'null',
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': 0,
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String? productId = ModalRoute.of(context)?.settings.arguments as String?;
      // print(productId);
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductData>(context, listen: false).find(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl' : _editedProduct.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        //Update Product
        if (_editedProduct.id != 'null') {
          await Provider.of<ProductData>(context, listen: false)
              .updateProduct(_editedProduct.id, _editedProduct);
        }
        //Adding New Product
        else {
          await Provider.of<ProductData>(context, listen: false)
              .addProducts(_editedProduct);
        }
      } catch (error) {
        await errorDialogue();
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      return;
    }
  }

  Future<Null?> errorDialogue() {
    return showDialog<Null>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('An Error Occured!'),
              content: const Text('Something went wrong'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'))
              ],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product Data'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'].toString(),
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_){
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value!,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a Title.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'].toString(),
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      // onFieldSubmitted: (_){
                      //   FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      // },
                      // focusNode: _priceFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value!),
                            isFavourite: _editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please Enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'].toString(),
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value.toString(),
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide Description.';
                        }
                        if (value.length < 10) {
                          return 'Description should be more than 10 characters long.';
                        }
                        return null;
                      },
                      // focusNode: _descriptionFocusNode,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter URL',
                                    textAlign: TextAlign.center)
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image Url',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value.toString(),
                                  price: _editedProduct.price,
                                  isFavourite: _editedProduct.isFavourite);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Valid Url';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
