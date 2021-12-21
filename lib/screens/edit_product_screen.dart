import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const namedRoute = '/edit_product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _edittedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _imageUrlNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlNode.dispose();
    super.dispose();
  }

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': '',
  };

  @override
  void initState() {
    //execute this func when ever the focus changes.
    //then dispose.
    _imageUrlNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // to make it run once.
    // didChangeDep can run multiple times.
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _edittedProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title': _edittedProduct.title,
          'description': _edittedProduct.description,
          'price': _edittedProduct.price.toString(),
          'imageurl': '',
        };
        _imageUrlController.text = _edittedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
              (!_imageUrlController.text.startsWith("http") &&
                  !_imageUrlController.text.startsWith("https"))
          //     ||
          // (!_imageUrlController.text.endsWith("png") &&
          //     !_imageUrlController.text.endsWith("jpg"))
          ) {
        return;
      }
      setState(() {});
    }
  }

  void saveForm() async {
    setState(() {
      _isLoading = true;
    });

    final isValid = _form.currentState!.validate();
    if (!isValid) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _form.currentState!.save();
    if (_edittedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct.id!, _edittedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_edittedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("An error Occured"),
                content: const Text("Something went wrong"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Ok"),
                  )
                ],
              );
            });
      } finally {}
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        actions: [
          IconButton(onPressed: saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Title"),
                      initialValue: _initValues['title'],
                      // move to the next input field.
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Provide a Title!";
                        }
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                            id: _edittedProduct.id,
                            title: value!,
                            description: _edittedProduct.description,
                            price: _edittedProduct.price,
                            imageUrl: _edittedProduct.imageUrl,
                            isFavorite: _edittedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                      initialValue: _initValues['price'],
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Provide a Price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please Enter a  valid number.";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please Enter a number greater than zero";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                            id: _edittedProduct.id,
                            title: _edittedProduct.title,
                            description: _edittedProduct.description,
                            price: double.parse(value!),
                            imageUrl: _edittedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "description"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      initialValue: _initValues['description'],
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Provide a Description";
                        }
                        if (value.length < 10) {
                          return "Should be at least 10 character..";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                            id: _edittedProduct.id,
                            title: _edittedProduct.title,
                            description: value!,
                            price: _edittedProduct.price,
                            imageUrl: _edittedProduct.imageUrl,
                            isFavorite: _edittedProduct.isFavorite);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter a URL!")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            initialValue: _initValues['imageUrl'],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide an Image URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please provide a valid Image URL';
                              }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please provide a valid Image URL';
                              // }
                              return null;
                            },

                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                            onSaved: (value) {
                              _edittedProduct = Product(
                                  id: _edittedProduct.id,
                                  title: _edittedProduct.title,
                                  description: _edittedProduct.description,
                                  price: _edittedProduct.price,
                                  imageUrl: value!,
                                  isFavorite: _edittedProduct.isFavorite);
                            },
                            // cause we want to have the image before it be submitted.
                            // because the controller can be updated when we type on the form fields.
                            controller: _imageUrlController,
                            focusNode: _imageUrlNode,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
