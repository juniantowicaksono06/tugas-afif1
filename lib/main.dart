import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class PhotoUploadWidget extends StatefulWidget {
  @override
  _PhotoUploadWidgetState createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  File? _image;

  // Function to pick an image from the device's gallery.
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image != null)
          Image.file(_image!) // Display the selected image.
        else
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(children: [
                Text("No image selected", style: TextStyle(fontSize: 18),),
                ElevatedButton(
                onPressed: _pickImage,
                child: Text("Pilih foto"),
              )
            ]),
          ) 
      ],
    );
  }
}


class _MyFormState extends State<MyForm> {
  String? selectedOption = 'Biasa';
  TextEditingController hasil = TextEditingController();
  TextEditingController nomorNota = TextEditingController();
  TextEditingController namaPelanggan = TextEditingController();
  TextEditingController tanggalBeli = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController jumlahBeli = TextEditingController(text: "0");
  TextEditingController diskon = TextEditingController(text: "0");
  TextEditingController ppn = TextEditingController(text: "0");
  TextEditingController grandTotal = TextEditingController(text: "0");
  TextEditingController uangDibayar = TextEditingController(text: "0");
  TextEditingController uangKembali = TextEditingController(text: "0");
  FocusNode _focusNodeJumlah = FocusNode();
  FocusNode _focusNodeDibayar = FocusNode();
  File? _image;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  

  List<String> options = ['Tidak', 'Ya'];
  String? selectedLibur = 'Tidak';
  String? selectedSaudara = "Tidak";
  bool ABC = false;
  bool BBB = false;
  bool XYZ = false;
  bool WWW = false;

  void proses() {
    String hasilNoNota = nomorNota.text;
    String hasilNamaPembeli = namaPelanggan.text;
    String? hasilJenis = selectedOption;
    String hasilDiskon = diskon.text;
    String hasilTanggalPembelian = tanggalBeli.text;
    String? hasilHariLibur = selectedLibur;
    String? hasilSaudara = selectedSaudara;
    String? hasilJenisBarang = "";
    String hasilPpn = ppn.text;
    String hasilGrandTotal = grandTotal.text;
    String hasilUangDibayar = uangDibayar.text;
    String hasilUangKembali = uangKembali.text;
    int localJmlBeli = jumlahBeli.text != "" ? int.parse(jumlahBeli.text.replaceAll(".", "")) : 0;
    if(ABC) {
      hasilJenisBarang = "$hasilJenisBarang\n - ABC";
    }
    if(BBB) {
      hasilJenisBarang = "$hasilJenisBarang\n - BBB";
    }
    if(XYZ) {
      hasilJenisBarang = "$hasilJenisBarang\n - XYZ";
    }
    if(WWW) {
      hasilJenisBarang = "$hasilJenisBarang\n - WWW";
    }

    if(ABC) {
      localJmlBeli += 100;
    }
    if(BBB) {
      localJmlBeli -= 500;
    }
    if(XYZ) {
      localJmlBeli += 200;
    }
    if(WWW && localJmlBeli > 0) {
      localJmlBeli -= 100;
    }
    if(selectedLibur == "Ya") {
      if(localJmlBeli > 0 && localJmlBeli >= 2500) {
        localJmlBeli -= 2500;
      }
      else {
        localJmlBeli = 0;
      }
    }
    if(selectedSaudara == "Tidak") {
      localJmlBeli += 3000;
    }
    else {
      if(localJmlBeli > 0 && localJmlBeli >= 5000) {
        localJmlBeli -= 5000;
      }
      else {
        localJmlBeli = 0;
      }
    }


    String hasilJumlahPembelian = int.parse(localJmlBeli.toString()).toString();
    double gt = double.parse(grandTotal.text.replaceAll(".", ""));
    double jl = double.parse(hasilJumlahPembelian.replaceAll(".", ""));
    double uk = double.parse(uangKembali.text.replaceAll(".", ""));
    double dk = double.parse(diskon.text.replaceAll(".", ""));
    hasilGrandTotal = gt.toStringAsFixed(gt.truncateToDouble() == gt ? 0: 1);
    hasilUangKembali = uk.toStringAsFixed(uk.truncateToDouble() == uk ? 0: 1);
    hasilJumlahPembelian = jl.toStringAsFixed(jl.truncateToDouble() == jl ? 0: 1);
    hasilDiskon = dk.toStringAsFixed(dk.truncateToDouble() == dk ? 0: 1);
    hasilUangKembali = NumberFormat("#,##0", "en_US").format(int.parse(hasilUangKembali)).replaceAll(',', '.');
    hasilGrandTotal = NumberFormat("#,##0", "en_US").format(int.parse(hasilGrandTotal)).replaceAll(',', '.');
    hasilJumlahPembelian = NumberFormat("#,##0", "en_US").format(int.parse(hasilJumlahPembelian)).replaceAll(',', '.');
    hasilDiskon = NumberFormat("#,##0", "en_US").format(int.parse(hasilDiskon)).replaceAll(',', '.');
    
    
    hasil.text = "Nomor Nota: $hasilNoNota\nNama Pembeli: $hasilNamaPembeli\nJenis: $hasilJenis\nTanggal Beli: $hasilTanggalPembelian\nJumlah Pembelian: $hasilJumlahPembelian\nNominal Diskon: $hasilDiskon\nHari Libur: $hasilHariLibur\nSaudara: $hasilSaudara\nJenis Barang Dibeli: $hasilJenisBarang\nPPN: $hasilPpn%\nGrand Total: $hasilGrandTotal\nUang Dibayar: $hasilUangDibayar\nUang Kembali: $hasilUangKembali";
  }

  void reset() {
    setState(() {
      hasil.text = "";
      nomorNota.text = "";
      namaPelanggan.text = "";
      tanggalBeli.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      jumlahBeli.text = "0";
      diskon.text = "0";
      ppn.text = "0";
      grandTotal.text = "0";
      uangDibayar.text = "0";
      uangKembali.text = "0";
        
      ABC = false;
      BBB = false;
      XYZ = false;
      WWW = false;
      selectedLibur = "Tidak";
      selectedSaudara = "Tidak";
      selectedOption = "Biasa";
      _image = null;
    });
  }


  void changeDiskon() {
      double nominalDiskon = 0;
      int localJmlBeli = jumlahBeli.text != "" ? int.parse(jumlahBeli.text.replaceAll(".", "")) : 0;
      if(ABC) {
        localJmlBeli += 100;
      }
      if(BBB) {
        localJmlBeli -= 500;
      }
      if(XYZ) {
        localJmlBeli += 200;
      }
      if(WWW && localJmlBeli > 0) {
        localJmlBeli -= 100;
      }
      if(selectedLibur == "Ya") {
        if(localJmlBeli > 0 && localJmlBeli >= 2500) {
          localJmlBeli -= 2500;
        }
        else {
          localJmlBeli = 0;
        }
      }
      if(selectedSaudara == "Tidak") {
        localJmlBeli += 3000;
      }
      else {
        if(localJmlBeli > 0 && localJmlBeli >= 5000) {
          localJmlBeli -= 5000;
        }
        else {
          localJmlBeli = 0;
        }
      }
      if(selectedOption == 'Pelanggan') {
        nominalDiskon = ((2 / 100) * localJmlBeli);
      }
      else if(selectedOption == "Pelanggan Istimewa") {
        nominalDiskon = ((4 / 100) * localJmlBeli);
      }
      else {
        nominalDiskon = 0;
      }

      diskon.text = nominalDiskon.toInt().toString();
      diskon.text = NumberFormat("#,##0", "en_US").format(int.parse(diskon.text.replaceAll(".", ""))).replaceAll(',', '.'); 
  }

  void onFocusJumlahBeli() {    
      if(!_focusNodeJumlah.hasFocus) {
        jumlahBeli.text = NumberFormat("#,##0", "en_US").format(int.parse(jumlahBeli.text.replaceAll(".", ''))).replaceAll(',', '.');
      }
      else {
        jumlahBeli.text = jumlahBeli.text.replaceAll(".", "");
      }
      changeDiskon();
      onPriceChange();
  }

  void onFocusDibayar() {    
      if(!_focusNodeJumlah.hasFocus) {
        uangDibayar.text = NumberFormat("#,##0", "en_US").format(int.parse(uangDibayar.text.replaceAll(".", ""))).replaceAll(',', '.');
      }
      else {
        uangDibayar.text = uangDibayar.text.replaceAll(".", "");
      }
  }

  void onPriceChange() {
    int localJmlBeli = jumlahBeli.text != "" ? int.parse(jumlahBeli.text.replaceAll(".", "")) : 0;
    // int localDiskon = diskon.text != "" ? int.parse(diskon.text.replaceAll(".", "")) : 0;
    int localPpn = ppn.text != "" ? int.parse(ppn.text) : 0;
    if(ABC) {
      localJmlBeli += 100;
    }
    if(BBB) {
      localJmlBeli -= 500;
    }
    if(XYZ) {
      localJmlBeli += 200;
    }
    if(WWW && localJmlBeli > 0) {
      localJmlBeli -= 100;
    }
    if(selectedLibur == "Ya") {
      if(localJmlBeli > 0 && localJmlBeli >= 2500) {
        localJmlBeli -= 2500;
      }
      else {
        localJmlBeli = 0;
      }
    }
    if(selectedSaudara == "Tidak") {
      localJmlBeli += 3000;
    }
    else {
      if(localJmlBeli > 0 && localJmlBeli >= 5000) {
        localJmlBeli -= 5000;
      }
      else {
        localJmlBeli = 0;
      }
    }

       

    grandTotal.text = localJmlBeli.toString();
    grandTotal.text = (int.parse(grandTotal.text) - int.parse(diskon.text.replaceAll(".", ""))).toString();
    // if(localDiskon > 0 && localJmlBeli > 0) {
    //   grandTotal.text = ((localJmlBeli - ((localDiskon / 100) * localJmlBeli))).toString();
    // }
    if(localPpn > 0 && localJmlBeli > 0) {
      grandTotal.text = (double.parse(grandTotal.text) + ((double.parse(grandTotal.text) * localPpn) / 100)).toString();
    }
    grandTotal.text = double.parse(grandTotal.text).toInt().toString();
    
    uangKembali.text = "0";
    if(uangDibayar.text.replaceAll(".", "") != "") {
      if(double.parse(uangDibayar.text.replaceAll(".", "")) > 0 && double.parse(grandTotal.text) > 0) {
        if(double.parse(uangDibayar.text.replaceAll(".", "")) > double.parse(grandTotal.text)) {
          uangKembali.text = (double.parse(uangDibayar.text.replaceAll(".", "")) - double.parse(grandTotal.text)).toString();
        }
      }
    }
    double gt = double.parse(grandTotal.text);
    double uk = double.parse(uangKembali.text);
    grandTotal.text = gt.toStringAsFixed(gt.truncateToDouble() == gt ? 0: 1);
    uangKembali.text = uk.toStringAsFixed(uk.truncateToDouble() == uk ? 0: 1);
    uangKembali.text = NumberFormat("#,##0", "en_US").format(int.parse(uangKembali.text)).replaceAll(',', '.');
    grandTotal.text = NumberFormat("#,##0", "en_US").format(int.parse(grandTotal.text)).replaceAll(',', '.');
  }

  List<String> dropdownOptions = ['Biasa', 'Pelanggan', 'Pelanggan Istimewa'];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        // selectedDate = picked;
        tanggalBeli.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    diskon.addListener(onPriceChange);
    jumlahBeli.addListener(() {
      onPriceChange();
    });
    uangDibayar.addListener(() {
      onPriceChange();
    });
    ppn.addListener(onPriceChange);
    onPriceChange();
    _focusNodeJumlah.addListener(onFocusJumlahBeli);
    _focusNodeDibayar.addListener(onFocusDibayar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: nomorNota,
                decoration: InputDecoration(labelText: 'Nomor Nota'),
              ),
              TextField(
                controller: namaPelanggan,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
              ),
              Row(children: <Widget>[
                Expanded(child: 
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                          double nominalDiskon = 0;
                          int localJmlBeli = jumlahBeli.text != "" ? int.parse(jumlahBeli.text.replaceAll(".", "")) : 0;
                          if(ABC) {
                            localJmlBeli += 100;
                          }
                          if(BBB) {
                            localJmlBeli -= 500;
                          }
                          if(XYZ) {
                            localJmlBeli += 200;
                          }
                          if(WWW && localJmlBeli > 0) {
                            localJmlBeli -= 100;
                          }
                          if(selectedLibur == "Ya") {
                            if(localJmlBeli > 0 && localJmlBeli >= 2500) {
                              localJmlBeli -= 2500;
                            }
                            else {
                              localJmlBeli = 0;
                            }
                          }
                          if(selectedSaudara == "Tidak") {
                            localJmlBeli += 3000;
                          }
                          else {
                            if(localJmlBeli > 0 && localJmlBeli >= 5000) {
                              localJmlBeli -= 5000;
                            }
                            else {
                              localJmlBeli = 0;
                            }
                          }
                          if(newValue == 'Pelanggan') {
                            nominalDiskon = ((2 / 100) * localJmlBeli);
                          }
                          else if(newValue == "Pelanggan Istimewa") {
                            nominalDiskon = ((4 / 100) * localJmlBeli);
                          }
                          else {
                            nominalDiskon = 0;
                          }

                          diskon.text = nominalDiskon.toInt().toString();
                          diskon.text = NumberFormat("#,##0", "en_US").format(int.parse(diskon.text.replaceAll(".", ""))).replaceAll(',', '.'); 
                          onPriceChange();
                        });
                      },
                      items: dropdownOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],),
              Row(children: [
                Expanded(child: TextField(
                  controller: tanggalBeli,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Tanggal Beli"
                  ),
                  onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101)
                      );
                      if(pickedDate != null ){
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          setState(() {
                            tanggalBeli.text = formattedDate; //set foratted date to TextField value. 
                          });
                      }else{
                          print("Date is not selected");
                      }
                  },
                ),)
              ],),
              TextField(
                controller: jumlahBeli,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                decoration: InputDecoration(labelText: 'Jumlah Pembelian'),
                focusNode: _focusNodeJumlah,
              ),
              TextField(
                controller: diskon,
                enabled: false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                decoration: InputDecoration(labelText: 'Diskon'),
              ),
              Row(children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("Libur", style: TextStyle(fontSize: 18)),)
              ],),
              Row(children: options.map((option) {
                return Row(children: [
                    Radio(
                      value: option,
                      groupValue: selectedLibur,
                      onChanged: (value) {
                        setState(() {
                          selectedLibur = value;
                          onPriceChange();
                        });
                      },
                    ),
                    Text(option)
                ],);
                }).toList()
              ,),
              Row(children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("Saudara", style: TextStyle(fontSize: 18)),)
              ],),
              Row(children: options.map((option) {
                return Row(children: [
                    Radio(
                      value: option,
                      groupValue: selectedSaudara,
                      onChanged: (value) {
                        setState(() {
                          selectedSaudara = value;
                          onPriceChange();
                        });
                      },
                    ),
                    Text(option)
                ],);
                }).toList()
              ,),
              Row(children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("Jenis Barang Dibeli", style: TextStyle(fontSize: 18)),)
              ],),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: ABC,
                        onChanged: (value) {
                          setState(() {
                            ABC = value!;
                            changeDiskon();
                            onPriceChange();
                          });
                        },
                      ),
                      Text("ABC", style: TextStyle(fontSize: 18)),
                      Checkbox(
                        value: BBB,
                        onChanged: (value) {
                          setState(() {
                            BBB = value!;
                            changeDiskon();
                            onPriceChange();
                          });
                        },
                      ),
                      Text("BBB", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: XYZ,
                        onChanged: (value) {
                          setState(() {
                            XYZ = value!;
                            changeDiskon();
                            onPriceChange();
                          });
                        },
                      ),
                      Text("XYZ", style: TextStyle(fontSize: 18)),
                      Checkbox(
                        value: WWW,
                        onChanged: (value) {
                          setState(() {
                            WWW = value!;
                            changeDiskon();
                            onPriceChange();
                          });
                        },
                      ),
                      Text("WWW", style: TextStyle(fontSize: 18)),
                    ],
                  )
                ]
              ),
              TextField(
                controller: ppn,
                decoration: InputDecoration(labelText: 'PPN'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
              ),
              TextField(
                controller: grandTotal,
                decoration: InputDecoration(labelText: 'Grand Total'),
                enabled: false,
              ),
              TextField(
                controller: uangDibayar,
                decoration: InputDecoration(labelText: 'Uang Dibayar'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                focusNode: _focusNodeDibayar,
              ),
              TextField(
                controller: uangKembali,
                decoration: InputDecoration(labelText: 'Uang Kembali'),
                enabled: false,
              ),
              Row(
                children: [
                  Expanded(child: 
                    Column(
                      children: [
                        if (_image != null)
                          Image.file(_image!) // Display the selected image.
                        else
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Column(children: [
                                Text("No image selected", style: TextStyle(fontSize: 18),),
                                ElevatedButton(
                                onPressed: _pickImage,
                                child: Text("Pilih foto"),
                              )
                            ]),
                          ) 
                      ],
                    )
                  ,)
                  // Expanded(child: PhotoUploadWidget())
                  // PhotoUploadWidget()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: proses, child: Text("Proses", style: TextStyle(fontSize: 18),)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(onPressed: reset, style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Change this color to your desired color
                    ), child: Text("Reset", style: TextStyle(fontSize: 18),),)
                  )
                ],
              ),
              ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 200.0, // Set your desired minimal width here
              ),
              child: Container(
                  color: Colors.grey,
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: TextField(decoration: InputDecoration.collapsed(hintText: ""), controller: hasil, maxLines: 20, enabled: false)
                )
              )
            ],
          ),
        )
      ),
    );
  }
}
