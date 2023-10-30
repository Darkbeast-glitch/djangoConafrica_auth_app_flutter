
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //       icon: Icon(
    //         Icons.arrow_back_ios,
    //         color: primaryColor,
    //         size: 20,
    //       ),
    //     ),
    //     centerTitle: true,
    //     backgroundColor: transparentColor,
    //     elevation: 0,
    //     title: Text(
    //       "DjangoCon Africa",
    //       style: TextStyle(
    //         color: secondaryColor,
    //         fontWeight: FontWeight.bold,
    //         fontSize: 23,
    //       ),
    //     ),
    //   ),
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Container(
    //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
    //         width: 332,
    //         height: 131,
    //         decoration: BoxDecoration(
    //           color: primaryColor,
    //           borderRadius: BorderRadius.circular(16),
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   fullName,
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: 5),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   email,
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.w400,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: 5),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   country,
    //                   style: TextStyle(fontSize: 18, color: Colors.white),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //       SizedBox(height: 10),
    //       Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(height: 20),
    //             Text(
    //               'Tickets:',
    //               style: TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 18,
    //               ),
    //             ),
    //             Column(
    //               children: tickets
    //                   .asMap()
    //                   .entries
    //                   .map(
    //                     (entry) => ListTile(
    //                       title: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text(
    //                             entry.value['ticket_name'] != null
    //                                 ? entry.value['ticket_name']
    //                                 : 'Ticket Name Unavailable',
    //                             style: TextStyle(
    //                               fontSize: 16,
    //                             ),
    //                           ),
    //                           // If it's the "Donation" ticket, disable the switch
    //                           if (entry.value['ticket_name'] == 'Donation')
    //                             Switch(
    //                               value: entry.value['status'],
    //                               onChanged: null,
    //                             )
    //                           else
    //                             Row(
    //                               children: [
    //                                 Text(
    //                                   entry.value['status']
    //                                       ? 'Enrolled'
    //                                       : 'Enroll',
    //                                   style: TextStyle(
    //                                       color: entry.value['status']
    //                                           ? Colors.green
    //                                           : Colors.red,
    //                                       fontWeight: FontWeight.bold),
    //                                 ),
    //                                 Switch(
    //                                   value: entry.value['status'],
    //                                   onChanged: entry.value['status']
    //                                       ? null // If already enrolled, disable the switch
    //                                       : (value) {
    //                                           _toggleEnrollment(
    //                                               value, entry.key);
    //                                         },
    //                                 ),
    //                               ],
    //                             ),
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                   .toList(),
    //             ),
    //             SizedBox(height: 60),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Image.asset(
    //                   "images/djangocon.png",
    //                   height: 75,
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text("DjangoCon Africa © 2023"),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
   
   
    // );