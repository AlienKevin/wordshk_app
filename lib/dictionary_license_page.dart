import 'package:flutter/material.dart';

import 'navigation_drawer.dart';

class DictionaryLicensePage extends StatelessWidget {
  const DictionaryLicensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Dictionary License')),
        drawer: const NavigationDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    r'All dictionary entries in this app (words.hk) are licensed under the Non-Commercial Open Data License.',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),
                Text("""
Copyright (c) 2015-2022, Hong Kong Lexicography Limited. All rights reserved.
You may be eligible for a license to use this work under the Non-Commercial
Open Data License.

THIS WORK IS PROVIDED BY THE AUTHORS AND/OR COPYRIGHT OWNERS ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHORS AND/OR COPYRIGHT OWNERS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
WORK, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


The Non-Commercial Open Data License 1.0

Section 0. Definitions

- "Author" means the author(s) of the Licensed Work.
- "Licensed Work" means the Copyrighted Work(s) covered by this license.
- "Licensor" means the licensor(s) to this license agreement, or the copyright
  owners of the Licensed Work, whichever is applicable.
- "You" means the licensee(s) to this license agreement.
- "Commercial Use" and "Commercial Purpose" has the meaning defined in Section 2.
- A "Credits List" may be provided by the Licensor.

Section 1. License Grant

You are granted a license to copy, reproduce, modify, adapt, publish,
translate, create derivative works from, distribute, redistribute, perform,
display, or otherwise use the Licensed Work, in whole or in part and/or to
incorporate it in other works in any form, media, provided that all the
following conditions are met:

  (a) You do not use the Licensed Work for Commercial Purposes as defined
      in Section 2 unless the conditions in Section 3 are met.

  (b) (i) All distributions of the Licensed Work or its derivatives in any form
      must reproduce the above copyright notice, the above disclaimer, and the
      Credits List (if given) in the documentation and/or other materials
      provided with the distribution.

      (ii) Additionally, if you obtained the Licensed Work from a website
      managed by the Licensor, all distributions of the Licensed Work must
      display a prominent link to that website.

      (iii) Notwithstanding (i) and (ii) above, if part of the Licensed Work is
      publicly available (without having the viewer to sign up or log in) in a
      single URL hosted by the Licensor, You may distribute such part of the
      Licensed Work under the condition that the following notice be
      accompanied with the distribution and displayed in a reasonably prominent
      manner:

      "Licensed under the Non-Commercial Open Data License ( http://the.URL/path )"

      The URL in the notice should be replaced with the actual URL that
      contains the part of the Licensed Work that is so distributed. You may
      not substitute the URL for any other URL, even if the other URL contains
      the same content or redirects to the original URL. The Licensor may
      provide alternative forms of the notice, in which case such provided form
      shall be used instead of the one set out above.

  (c) You do not use the name of the Author nor the Licensor to endorse or
      promote products derived from the Licensed Work without prior written
      permission.

  (d) You do not sub-license any or parts of the Licensed Work. (You may,
      however, refer potential licensees to the Licensor, or, if applicable,
      the Licensor's website, for the purpose of obtaining a license)

Section 2. Meaning of "Commercial Use"

"Commercial Purposes" and "Commercial Use" DOES include, but is not limited to,
the following:

  a) Collecting advertisement fees from a website or an Internet accessible
     location that uses, displays, exhibits, or otherwise makes non-trivial use
     of the Licensed Work.

  b) Selling any service using the Licensed Work as a value added component.

  c) Publishing the Licensed Work in exchange for valuable consideration.

  d) Teaching an educational course based substantially on the Licensed
     Work for valuable consideration.

  e) Performing the Licensed Work or a derivative work of the Licensed Work for
     valuable consideration.

  f) Any use of the Licensed Work normally protected by copyright, in a
     commercial setting, regardless of whether such use is incidental to, or
     whether it forms a "core" part of the business.

In determining whether a use of the Licensed Work is for Commercial
Purposes, it is immaterial whether You make a profit or loss, it is immaterial
whether the purpose is for charity, educational, public service, or
"non-profit" purposes.

Subject to the terms in this section, "Commercial Purposes" and "Commercial
Use" shall bear the usual meaning.


Section 3. Exceptions to the restriction on Commercial Use

The restriction on the Commercial Use of the Licensed Work does not apply if
any of the following conditions are met:

  a) You have made separate agreements with the Licensor to use the Licensed
     Work under a different license.

  b) You have made good faith, non-intrusive attempts to reach out to the
     Licensor for the purpose of making a separate license in (a), but have
     failed to reach the Licensor, or they have failed to give a reply in six
     months. For the purpose of this subsection, all reasonable, non-intrusive
     communication channels must have been exhausted before You can rely on
     this exception.

     You may not rely on this exception if any Licensor have previously given
     You any reply whatsoever, even if not favorable to You, through any
     reasonable communication channel including public announcements on the
     Internet.

     You may not rely on this exception if any Licensor have already rejected
     requests You have made with or without reason, through any reasonable
     communication channel including public announcements on the Internet.

     This exception is not intended and cannot be construed as a waiver of any
     privacy rights or expectations of the Licensor, and does not give You any
     rights whatsoever to violate the privacy rights and expectations of the
     Licensor. You may not make more requests to the Licensor than is
     reasonable.

     This exception is not intended and cannot be construed as to impose any
     contractual obligations on the part of the Licensor to discuss,
     negotiate, reply or otherwise deal with Your request(s).

     You must keep records to prove that You have made such attempts.

     Not withstanding the terms in this subsection, if the Licensor has put up
     a public notice to convey their intention of not making separate licenses
     in any specified case or cases, You cannot rely on this subsection if You
     fall under such case or cases.

  c) The Licensed Work has been published for ten or more years.

     You cannot rely on this subsection for a newer version of the Licensed
     Work if only some older version(s) meet the conditions in this subsection;
     However, the publishing of a newer version of the Licensed Work will not
     extinguish Your rights to rely on this subsection with regard to the older
     Licensed Work(s) which meet the conditions of this subsection.

  d) Any use that would have been deemed "Fair Use" by the United States Federal
     Courts.

  e) Use in small personal businesses -- meaning You are using the Licensed
     Work in a personal business where You are a sole proprietor with revenue
     less than 3 times the personal median income in Your country or economic
     region, or if both is applicable, whichever is higher. Once Your business
     grows beyond this limit, You are given a temporary waiver of additional
     six months to make separate agreements with the Licensor by the means
     described in Section 3(a) and/or 3(b). The Licensor is under no obligation
     to agree to any terms beyond the scope of this License, and may refuse to
     make such separate agreements with or without reason.

     If You rely on this exemption, You agree to provide evidence that Your
     income meets the requirement of this section upon the Licensor's demand. A
     written and signed declaration to that effect, from a professional
     accountant who is recognized by a relevant professional body as such, is
     deemed sufficient. Any other reasonable way to provide such evidence is
     also acceptable. However, You providing such evidence does not in any way
     bar any persons taking legal action against You in case of a dispute.
                """, style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
          ),
        ));
  }
}
