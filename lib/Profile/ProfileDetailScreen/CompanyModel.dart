class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getListState() {
    return <Company>[
      Company(485, 'Acre'),
      Company(486, 'Alagoas'),
      Company(487, 'Amapá'),
      Company(488, 'Amazonas'),
      Company(489, 'Bahia'),
      Company(490, 'Ceará'),
      Company(511, 'Distrito Federal'),
      Company(491, 'Espírito Santo'),
      Company(492, 'Goiás'),
      Company(493, 'Maranhão'),
      Company(494, 'Mato Grosso'),
      Company(495, 'Mato Grosso do Sul'),
      Company(496, 'Minas Gerais'),
      Company(499, 'Paraná'),
      Company(498, 'Paraíba'),
      Company(497, 'Pará'),
      Company(500, 'Pernambuco'),
      Company(501, 'Piauí'),
      Company(503, 'Rio Grande do Norte'),
      Company(504, 'Rio Grande do Sul'),
      Company(502, 'Rio de Janeiro'),
      Company(505, 'Rondônia'),
      Company(506, 'Roraima'),
      Company(507, 'Santa Catarina'),
      Company(509, 'Sergipe'),
      Company(508, 'São Paulo'),
      Company(510, 'Tocantins'),
    ];
  }
}
