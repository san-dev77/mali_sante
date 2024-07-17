import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailHopital extends StatelessWidget {
  final dynamic data;
  const DetailHopital({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: ClipPath(
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Center(
                  child: Card(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                //   child: AutoSizeText(
                                //     maxLines: 2,
                                //     minFontSize: 17,
                                //     style: const TextStyle(
                                //       fontWeight: FontWeight.w800,
                                //     ),
                                //   ),
                                ),
                            Divider(
                              color: Colors.grey[300],
                            ),
                            if (data['contact'].isNotEmpty)
                              ContactRow(
                                label: "Téléphone",
                                contact: data['contact'],
                              ),
                            if (data['contact2'].isNotEmpty)
                              ContactRow(
                                label: "Téléphone",
                                contact: data['contact2'],
                              ),
                            if (data['latitude'].isNotEmpty &&
                                data['longitude'].isNotEmpty)
                              Column(
                                children: [
                                  Divider(
                                    color: Colors.grey[300],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.map_rounded,
                                            color: Color.fromARGB(
                                                255, 63, 160, 217),
                                            size: 35,
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Text(
                                            "Itinéraire",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final query =
                                              '${data['latitude']},${data['longitude']}(${data['libelle']})';
                                          final uri = Uri(
                                            scheme: 'geo',
                                            host: '0,0',
                                            queryParameters: {'q': query},
                                          );

                                          await launchUrl(uri);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_circle_right_outlined,
                                          color:
                                              Color.fromARGB(255, 63, 160, 217),
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height * 0.03,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  final String label;
  final String contact;

  const ContactRow({
    Key? key,
    required this.label,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.call,
              color: Color.fromARGB(255, 63, 160, 217),
              size: 35,
            ),
            const SizedBox(
              width: 20.0,
            ),
            Column(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  contact,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            final phoneUrl = Uri(scheme: 'tel', path: contact);
            await canLaunchUrl(phoneUrl).then((bool result) {
              if (result) {
                launchUrl(phoneUrl);
              }
            });
          },
          icon: const Icon(
            Icons.arrow_circle_right_outlined,
            color: Color.fromARGB(255, 63, 160, 217),
            size: 30,
          ),
        ),
      ],
    );
  }
}
