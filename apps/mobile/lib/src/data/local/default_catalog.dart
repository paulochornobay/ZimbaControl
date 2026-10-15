class DefaultCategoryDefinition {
  const DefaultCategoryDefinition(
    this.kind,
    this.systemKey,
    this.name,
    this.iconKey,
    this.colorKey,
    this.sortOrder,
    this.children, {
    this.hidden = false,
  });
  final String kind;
  final String systemKey;
  final String name;
  final String iconKey;
  final String colorKey;
  final int sortOrder;
  final List<DefaultSubcategoryDefinition> children;
  final bool hidden;
}

class DefaultSubcategoryDefinition {
  const DefaultSubcategoryDefinition(this.systemKey, this.name);
  final String systemKey;
  final String name;
}

class DefaultContextDefinition {
  const DefaultContextDefinition(
    this.id,
    this.name,
    this.iconKey,
    this.colorKey,
  );
  final String id;
  final String name;
  final String iconKey;
  final String colorKey;
}

const defaultContextCatalog = <DefaultContextDefinition>[
  DefaultContextDefinition('system-context-home', 'Casa', 'home', 'green'),
  DefaultContextDefinition(
    'system-context-personal',
    'Pessoal',
    'personal',
    'slate',
  ),
  DefaultContextDefinition('system-context-work', 'Trabalho', 'work', 'blue'),
];

const defaultCategoryCatalog = <DefaultCategoryDefinition>[
  DefaultCategoryDefinition(
    'expense',
    'HOUSING',
    'Moradia',
    'home',
    'green',
    10,
    [
      DefaultSubcategoryDefinition('RENT_MORTGAGE', 'Aluguel / Financiamento'),
      DefaultSubcategoryDefinition('CONDO', 'Condomínio'),
      DefaultSubcategoryDefinition('ELECTRICITY', 'Energia'),
      DefaultSubcategoryDefinition('WATER', 'Água'),
      DefaultSubcategoryDefinition('GAS', 'Gás'),
      DefaultSubcategoryDefinition('HOME_INTERNET', 'Internet'),
      DefaultSubcategoryDefinition('HOME_MAINTENANCE', 'Manutenção'),
      DefaultSubcategoryDefinition('DOMESTIC_SERVICES', 'Serviços domésticos'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'FOOD',
    'Alimentação',
    'cart',
    'amber',
    20,
    [
      DefaultSubcategoryDefinition('GROCERIES', 'Supermercado'),
      DefaultSubcategoryDefinition('BAKERY', 'Padaria'),
      DefaultSubcategoryDefinition('RESTAURANT', 'Restaurante'),
      DefaultSubcategoryDefinition('DELIVERY', 'Delivery'),
      DefaultSubcategoryDefinition('SNACKS', 'Lanches'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'TRANSPORT',
    'Transporte',
    'transport',
    'cyan',
    30,
    [
      DefaultSubcategoryDefinition('FUEL', 'Combustível'),
      DefaultSubcategoryDefinition('PARKING', 'Estacionamento'),
      DefaultSubcategoryDefinition('TOLL', 'Pedágio'),
      DefaultSubcategoryDefinition('VEHICLE_MAINTENANCE', 'Manutenção'),
      DefaultSubcategoryDefinition('VEHICLE_INSURANCE', 'Seguro'),
      DefaultSubcategoryDefinition('VEHICLE_TAX', 'IPVA / Licenciamento'),
      DefaultSubcategoryDefinition('RIDE_HAILING', 'Aplicativo / Táxi'),
      DefaultSubcategoryDefinition('PUBLIC_TRANSPORT', 'Transporte público'),
    ],
  ),
  DefaultCategoryDefinition('expense', 'HEALTH', 'Saúde', 'health', 'red', 40, [
    DefaultSubcategoryDefinition('PHARMACY', 'Farmácia'),
    DefaultSubcategoryDefinition('MEDICAL_APPOINTMENT', 'Consulta'),
    DefaultSubcategoryDefinition('MEDICAL_EXAMS', 'Exames'),
    DefaultSubcategoryDefinition('HEALTH_INSURANCE', 'Plano de saúde'),
    DefaultSubcategoryDefinition('DENTAL', 'Odontologia'),
    DefaultSubcategoryDefinition('THERAPY', 'Terapia'),
    DefaultSubcategoryDefinition('OTHER_TREATMENT', 'Outros tratamentos'),
  ]),
  DefaultCategoryDefinition(
    'expense',
    'EDUCATION',
    'Educação',
    'education',
    'blue',
    50,
    [
      DefaultSubcategoryDefinition('SCHOOL', 'Escola / Faculdade'),
      DefaultSubcategoryDefinition('COURSES', 'Cursos'),
      DefaultSubcategoryDefinition('SCHOOL_SUPPLIES', 'Material escolar'),
      DefaultSubcategoryDefinition('BOOKS', 'Livros'),
      DefaultSubcategoryDefinition('PRIVATE_LESSONS', 'Aulas particulares'),
      DefaultSubcategoryDefinition(
        'EXTRACURRICULAR',
        'Atividades extracurriculares',
      ),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'CLOTHING',
    'Vestuário',
    'clothing',
    'pink',
    60,
    [
      DefaultSubcategoryDefinition('CLOTHES', 'Roupas'),
      DefaultSubcategoryDefinition('SHOES', 'Calçados'),
      DefaultSubcategoryDefinition('ACCESSORIES', 'Acessórios'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'PERSONAL_CARE',
    'Cuidados pessoais',
    'personal-care',
    'purple',
    70,
    [
      DefaultSubcategoryDefinition('HYGIENE', 'Higiene'),
      DefaultSubcategoryDefinition('HAIR', 'Cabeleireiro / Barbearia'),
      DefaultSubcategoryDefinition('COSMETICS', 'Cosméticos'),
      DefaultSubcategoryDefinition('BEAUTY', 'Estética'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'HOME_GOODS',
    'Casa',
    'home-goods',
    'green',
    80,
    [
      DefaultSubcategoryDefinition('FURNITURE', 'Móveis'),
      DefaultSubcategoryDefinition('APPLIANCES', 'Eletrodomésticos'),
      DefaultSubcategoryDefinition('HOME_ELECTRONICS', 'Eletrônicos'),
      DefaultSubcategoryDefinition('HOUSEHOLD_ITEMS', 'Utensílios'),
      DefaultSubcategoryDefinition('DECORATION', 'Decoração'),
      DefaultSubcategoryDefinition('GARDEN', 'Jardim'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'LEISURE',
    'Lazer',
    'leisure',
    'purple',
    90,
    [
      DefaultSubcategoryDefinition('OUTINGS', 'Passeios'),
      DefaultSubcategoryDefinition('CINEMA', 'Cinema'),
      DefaultSubcategoryDefinition('GAMES', 'Jogos'),
      DefaultSubcategoryDefinition('HOBBIES', 'Hobbies'),
      DefaultSubcategoryDefinition('EVENTS', 'Eventos'),
      DefaultSubcategoryDefinition('TOYS', 'Brinquedos'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'SUBSCRIPTIONS',
    'Assinaturas',
    'subscriptions',
    'blue',
    100,
    [
      DefaultSubcategoryDefinition('STREAMING', 'Streaming'),
      DefaultSubcategoryDefinition('MUSIC', 'Música'),
      DefaultSubcategoryDefinition('APPS', 'Aplicativos'),
      DefaultSubcategoryDefinition('SOFTWARE', 'Software'),
      DefaultSubcategoryDefinition('MEMBERSHIPS', 'Clubes / Assinaturas'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'SPORTS_WELLNESS',
    'Esporte e bem-estar',
    'wellness',
    'cyan',
    110,
    [
      DefaultSubcategoryDefinition('GYM', 'Academia'),
      DefaultSubcategoryDefinition('SPORTS', 'Esportes'),
      DefaultSubcategoryDefinition('SPORTS_EQUIPMENT', 'Equipamentos'),
      DefaultSubcategoryDefinition('SUPPLEMENTS', 'Suplementos'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'FINANCIAL_EXPENSES',
    'Financeiro',
    'financial',
    'slate',
    120,
    [
      DefaultSubcategoryDefinition('INTEREST', 'Juros'),
      DefaultSubcategoryDefinition('BANK_FEES', 'Tarifas'),
      DefaultSubcategoryDefinition('IOF', 'IOF'),
      DefaultSubcategoryDefinition('FINES', 'Multas'),
      DefaultSubcategoryDefinition('CARD_FEE', 'Anuidade'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'GIFTS_DONATIONS',
    'Presentes e doações',
    'gift',
    'pink',
    130,
    [
      DefaultSubcategoryDefinition('GIFTS', 'Presentes'),
      DefaultSubcategoryDefinition('DONATIONS', 'Doações'),
      DefaultSubcategoryDefinition('CONTRIBUTIONS', 'Contribuições'),
    ],
  ),
  DefaultCategoryDefinition(
    'expense',
    'OTHER_EXPENSE',
    'Outros',
    'other',
    'slate',
    140,
    [
      DefaultSubcategoryDefinition('UNIDENTIFIED', 'Não identificado'),
      DefaultSubcategoryDefinition('OTHER', 'Outros'),
    ],
  ),
  DefaultCategoryDefinition('expense', 'PETS', 'Pets', 'pets', 'amber', 150, [
    DefaultSubcategoryDefinition('PET_SHOP', 'Pet shop'),
    DefaultSubcategoryDefinition('PET_FOOD', 'Ração'),
    DefaultSubcategoryDefinition('VETERINARY', 'Veterinário'),
    DefaultSubcategoryDefinition('PET_MEDICINE', 'Medicamentos'),
    DefaultSubcategoryDefinition('GROOMING', 'Banho / Tosa'),
  ], hidden: true),
  DefaultCategoryDefinition(
    'expense',
    'TRAVEL',
    'Viagens',
    'travel',
    'blue',
    160,
    [
      DefaultSubcategoryDefinition('LODGING', 'Hospedagem'),
      DefaultSubcategoryDefinition('TICKETS', 'Passagens'),
      DefaultSubcategoryDefinition('TRAVEL_FOOD', 'Alimentação'),
      DefaultSubcategoryDefinition('TRAVEL_TRANSPORT', 'Transporte'),
      DefaultSubcategoryDefinition('TOURS', 'Passeios'),
    ],
    hidden: true,
  ),
  DefaultCategoryDefinition(
    'expense',
    'BUSINESS',
    'Negócio',
    'business',
    'blue',
    170,
    [
      DefaultSubcategoryDefinition('MATERIALS', 'Materiais'),
      DefaultSubcategoryDefinition('SERVICES', 'Serviços'),
      DefaultSubcategoryDefinition('BUSINESS_SOFTWARE', 'Software'),
      DefaultSubcategoryDefinition('TAXES', 'Impostos'),
      DefaultSubcategoryDefinition('OTHER', 'Outros'),
    ],
    hidden: true,
  ),
  DefaultCategoryDefinition(
    'income',
    'SALARY',
    'Salário',
    'income',
    'green',
    10,
    [
      DefaultSubcategoryDefinition('SALARY', 'Salário'),
      DefaultSubcategoryDefinition('THIRTEENTH_SALARY', '13º salário'),
      DefaultSubcategoryDefinition('VACATION', 'Férias'),
      DefaultSubcategoryDefinition('BONUS', 'Bônus / PLR'),
    ],
  ),
  DefaultCategoryDefinition(
    'income',
    'ALIMONY',
    'Pensão',
    'income',
    'green',
    20,
    [DefaultSubcategoryDefinition('ALIMONY', 'Pensão alimentícia')],
  ),
  DefaultCategoryDefinition(
    'income',
    'INVESTMENT_INCOME',
    'Investimentos',
    'income',
    'green',
    30,
    [
      DefaultSubcategoryDefinition('FIXED_INCOME', 'CDB / Renda fixa'),
      DefaultSubcategoryDefinition('DIVIDENDS', 'Dividendos'),
      DefaultSubcategoryDefinition('JCP', 'Juros sobre capital'),
      DefaultSubcategoryDefinition('FUNDS', 'Fundos'),
      DefaultSubcategoryDefinition('OTHER_INCOME', 'Outros rendimentos'),
    ],
  ),
  DefaultCategoryDefinition(
    'income',
    'INTEREST_INCOME',
    'Juros recebidos',
    'income',
    'green',
    40,
    [DefaultSubcategoryDefinition('LOAN_INTEREST', 'Juros de empréstimos')],
  ),
  DefaultCategoryDefinition(
    'income',
    'EXTRA_INCOME',
    'Trabalho extra',
    'work',
    'blue',
    50,
    [
      DefaultSubcategoryDefinition('FREELANCE', 'Freelance'),
      DefaultSubcategoryDefinition('SERVICES', 'Serviços'),
      DefaultSubcategoryDefinition('COMMISSIONS', 'Comissões'),
    ],
  ),
  DefaultCategoryDefinition(
    'income',
    'REFUND',
    'Reembolso',
    'income',
    'green',
    60,
    [
      DefaultSubcategoryDefinition('REFUND', 'Reembolso'),
      DefaultSubcategoryDefinition('RETURN', 'Devolução'),
    ],
  ),
  DefaultCategoryDefinition(
    'income',
    'SALE_INCOME',
    'Venda',
    'income',
    'green',
    70,
    [
      DefaultSubcategoryDefinition('ASSET_SALE', 'Venda de bens'),
      DefaultSubcategoryDefinition('PRODUCT_SALE', 'Venda de produtos'),
      DefaultSubcategoryDefinition('OTHER', 'Outros'),
    ],
  ),
  DefaultCategoryDefinition(
    'income',
    'OTHER_INCOME',
    'Outras receitas',
    'income',
    'green',
    80,
    [DefaultSubcategoryDefinition('OTHER', 'Outros')],
  ),
];
