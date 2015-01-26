/**
 * Склонение русских имён и фамилий
 *
 * var rn = new RussianName('Паниковский Михаил Самуэльевич');
 * rn.fullName(rn.gcaseRod); // Паниковского Михаила Самуэльевича
 *
 * Список констант по падежам см. ниже в коде.
 *
 * Пожалуйста, присылайте свои уточнения мне на почту. Спасибо.
 *
 * @version  0.1.4
 * @author   Johnny Woo <agalkin@agalkin.ru>
 */

var RussianNameProcessor = {
    sexM: 'm',
    sexF: 'f',
    gcaseIm:   'nominative',      gcaseNom: 'nominative',      // именительный
    gcaseRod:  'genitive',        gcaseGen: 'genitive',        // родительный
    gcaseDat:  'dative',                                       // дательный
    gcaseVin:  'accusative',      gcaseAcc: 'accusative',      // винительный
    gcaseTvor: 'instrumentative', gcaseIns: 'instrumentative', // творительный
    gcasePred: 'prepositional',   gcasePos: 'prepositional',   // предложный

    rules: {
        lastName: {
            exceptions: [
                '        дюма,тома,дега,люка,ферма,гамарра,петипа,шандра . . . . .',
                '        гусь,ремень,камень,онук,богода,нечипас,долгопалец,маненок,рева,кива . . . . .',
                '        вий,сой,цой,хой -я -ю -я -ем -е'
            ],
            suffixes: [
                'f        б,в,г,д,ж,з,й,к,л,м,н,п,р,с,т,ф,х,ц,ч,ш,щ,ъ,ь . . . . .',
                'f        ска,цка  -ой -ой -ую -ой -ой',
                'f        ая       --ой --ой --ую --ой --ой',
                '        ская     --ой --ой --ую --ой --ой',
                'f        на       -ой -ой -у -ой -ой',

                '        иной -я -ю -я -ем -е',
                '        уй   -я -ю -я -ем -е',
                '        ца   -ы -е -у -ей -е',

                '        рих  а у а ом е',

                '        ия                      . . . . .',
                '        иа,аа,оа,уа,ыа,еа,юа,эа . . . . .',
                '        их,ых                   . . . . .',
                '        о,е,э,и,ы,у,ю           . . . . .',

                '        ова,ева            -ой -ой -у -ой -ой',
                '        га,ка,ха,ча,ща,жа  -и -е -у -ой -е',
                '        ца  -и -е -у -ей -е',
                '        а   -ы -е -у -ой -е',

                '        ь   -я -ю -я -ем -е',

                '        ия  -и -и -ю -ей -и',
                '        я   -и -е -ю -ей -е',
                '        ей  -я -ю -я -ем -е',

                '        ян,ан,йн   а у а ом е',

                '        ынец,обец  --ца --цу --ца --цем --це',
                '        онец,овец  --ца --цу --ца --цом --це',

                '        ц,ч,ш,щ   а у а ем е',

                '        ай  -я -ю -я -ем -е',
                '        гой,кой  -го -му -го --им -м',
                '        ой  -го -му -го --ым -м',
                '        ах,ив   а у а ом е',

                '        ший,щий,жий,ний  --его --ему --его -м --ем',
                '        кий,ый   --ого --ому --ого -м --ом',
                '        ий       -я -ю -я -ем -и',

                '        ок  --ка --ку --ка --ком --ке',
                '        ец  --ца --цу --ца --цом --це',

                '        в,н   а у а ым е',
                '        б,г,д,ж,з,к,л,м,п,р,с,т,ф,х   а у а ом е'
            ]
        },
        firstName: {
            exceptions: [
                '        лев    --ьва --ьву --ьва --ьвом --ьве',
                '        павел  --ла  --лу  --ла  --лом  --ле',
                'm        шота   . . . . .',
                'f        рашель,нинель,николь,габриэль,даниэль   . . . . .'
            ],
            suffixes: [
                '        е,ё,и,о,у,ы,э,ю   . . . . .',
                'f        б,в,г,д,ж,з,й,к,л,м,н,п,р,с,т,ф,х,ц,ч,ш,щ,ъ   . . . . .',

                'f        ь   -и -и . ю -и',
                'm        ь   -я -ю -я -ем -е',

                '        га,ка,ха,ча,ща,жа  -и -е -у -ой -е',
                '        а   -ы -е -у -ой -е',
                '        ия  -и -и -ю -ей -и',
                '        я   -и -е -ю -ей -е',
                '        ей  -я -ю -я -ем -е',
                '        ий  -я -ю -я -ем -и',
                '        й   -я -ю -я -ем -е',
                '        б,в,г,д,ж,з,к,л,м,н,п,р,с,т,ф,х,ц,ч         а у а ом е'
            ]
        },
        middleName: {
            suffixes: [
                '        ич   а  у  а  ем  е',
                '        на  -ы -е -у -ой -е'
            ]
        }
    },

    initialized: false,
    init: function() {
        if(this.initialized) return;
        this.prepareRules();
        this.initialized = true;
    },

    prepareRules: function() {
        for(var type in this.rules) {
            for(var key in this.rules[type]) {
                for(var i = 0, n = this.rules[type][key].length; i < n; i++) {
                    this.rules[type][key][i] = this.rule(this.rules[type][key][i]);
                }
            }
        }
    },

    rule: function(rule) {
        var m = rule.match(/^\s*([fm]?)\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/);
        if(m) return {
            sex: m[1],
            test: m[2].split(','),
            mods: [m[3], m[4], m[5], m[6], m[7]]
        }
        return false;
    },

    // склоняем слово по указанному набору правил и исключений
    word: function(word, sex, wordType, gcase) {
        // исходное слово находится в именительном падеже
        if(gcase == this.gcaseNom) return word;

        // составные слова
        if(word.match(/[-]/)) {
            var list = word.split('-');
            for(var i = 0, n = list.length; i < n; i++) {
                list[i] = this.word(list[i], sex, wordType, gcase);
            }
            return list.join('-');
        }

        // Иванов И. И.
        if(word.match(/^[А-ЯЁ]\.?$/i)) return word;

        this.init();
        var rules = this.rules[wordType];

        if(rules.exceptions) {
            var pick = this.pick(word, sex, gcase, rules.exceptions, true);
            if(pick) return pick;
        }
        var pick = this.pick(word, sex, gcase, rules.suffixes, false);
        return pick || word;
    },

    // выбираем из списка правил первое подходящее и применяем
    pick: function(word, sex, gcase, rules, matchWholeWord) {
        wordLower = word.toLowerCase();
        for(var i = 0, n = rules.length; i < n; i++) {
            if(this.ruleMatch(wordLower, sex, rules[i], matchWholeWord)) {
                return this.applyMod(word, gcase, rules[i]);
            }
        }
        return false;
    },

    // проверяем, подходит ли правило к слову
    ruleMatch: function(word, sex, rule, matchWholeWord) {
        if(rule.sex == this.sexM && sex == this.sexF) return false; // male by default
        if(rule.sex == this.sexF && sex != this.sexF) return false;
        for(var i = 0, n = rule.test.length; i < n; i++) {
            var test = matchWholeWord ? word : word.substr(Math.max(word.length - rule.test[i].length, 0));
            if(test == rule.test[i]) return true;
        }
        return false;
    },

    // склоняем слово (правим окончание)
    applyMod: function(word, gcase, rule) {
        switch(gcase) {
            case this.gcaseNom: var mod = '.'; break;
            case this.gcaseGen: var mod = rule.mods[0]; break;
            case this.gcaseDat: var mod = rule.mods[1]; break;
            case this.gcaseAcc: var mod = rule.mods[2]; break;
            case this.gcaseIns: var mod = rule.mods[3]; break;
            case this.gcasePos: var mod = rule.mods[4]; break;
            default: throw "Unknown grammatic case: "+gcase;
        }
        for(var i = 0, n = mod.length; i < n; i++) {
            var c = mod.substr(i, 1);
            switch(c) {
                case '.': break;
                case '-': word = word.substr(0, word.length - 1); break;
                default: word += c;
            }
        }
        return word;
    }
}

// new RussianName('Козлов Евгений Павлович')      // годится обычная форма
// new RussianName('Евгений Павлович Козлов')      // в таком виде тоже
// new RussianName('Козлов', 'Евгений')        // можно явно указать составляющие
// new RussianName('Кунтидия', 'Убиреко', '', 'f') // можно явно указать пол ('m' или 'f')
var RussianName = function(lastName, firstName, middleName, sex) {
    if(typeof firstName == 'undefined') {
        var m = lastName.match(/^\s*(\S+)(\s+(\S+)(\s+(\S+))?)?\s*$/);
        if(!m) throw "Cannot parse supplied name";
        if(m[5] && m[3].match(/(ич|на)$/) && !m[5].match(/(ич|на)$/)) {
            // Иван Петрович Сидоров
            lastName = m[5];
            firstName = m[1];
            middleName = m[3];
            this.fullNameSurnameLast = true;
        } else {
            // Сидоров Иван Петрович
            lastName = m[1];
            firstName = m[3];
            middleName = m[5];
        }
    }
    this.ln = lastName;
    this.fn = firstName || '';
    this.mn = middleName || '';
    this.sex = sex || this.getSex();
}
RussianName.prototype = {
    // constants
    sexM: RussianNameProcessor.sexM,
    sexF: RussianNameProcessor.sexF,
    gcaseIm:   RussianNameProcessor.gcaseIm,   gcaseNom: RussianNameProcessor.gcaseNom, // именительный
    gcaseRod:  RussianNameProcessor.gcaseRod,  gcaseGen: RussianNameProcessor.gcaseGen, // родительный
    gcaseDat:  RussianNameProcessor.gcaseDat,                                           // дательный
    gcaseVin:  RussianNameProcessor.gcaseVin,  gcaseAcc: RussianNameProcessor.gcaseAcc, // винительный
    gcaseTvor: RussianNameProcessor.gcaseTvor, gcaseIns: RussianNameProcessor.gcaseIns, // творительный
    gcasePred: RussianNameProcessor.gcasePred, gcasePos: RussianNameProcessor.gcasePos, // предложный

    fullNameSurnameLast: false,

    ln: '', fn: '', mn: '', sex: '',
    // если пол явно не указан, его можно легко узнать по отчеству
    getSex: function() {
        if(this.mn.length > 2) {
            switch(this.mn.substr(this.mn.length - 2)) {
                case 'ич': return this.sexM;
                case 'на': return this.sexF;
            }
        }
        return '';
    },

    fullName: function(gcase) {
        return (
            (this.fullNameSurnameLast ? '' : this.lastName(gcase) + ' ')
                + this.firstName(gcase) + ' ' + this.middleName(gcase) +
                (this.fullNameSurnameLast ? ' ' + this.lastName(gcase) : '')
            ).replace(/^ +| +$/g, '');
    },
    lastName: function(gcase) {
        return RussianNameProcessor.word(this.ln, this.sex, 'lastName', gcase);
    },
    firstName: function(gcase) {
        return RussianNameProcessor.word(this.fn, this.sex, 'firstName', gcase);
    },
    middleName: function(gcase) {
        return RussianNameProcessor.word(this.mn, this.sex, 'middleName', gcase);
    }
}

$(document).ready(function() {
    /**
     * Проверяем на заполненность ФИО в именительном падеже.
     */
    function checkFill() {
        return (
            $('#user_fname_attributes_ip').val() &&
            $('#user_iname_attributes_ip').val() &&
            $('#user_oname_attributes_ip').val()
        );
    }

    $('#form-fio input').on('blur', function() {
        if (checkFill()) {
            var fio =
                $('#user_fname_attributes_ip').val()
                    + ' ' + $('#user_iname_attributes_ip').val()
                    + ' ' + $('#user_oname_attributes_ip').val();
            var procFio = new RussianName(fio);
            $('#user_iname_attributes_rp').val(procFio.firstName(procFio.gcaseRod));
            $('#user_iname_attributes_dp').val(procFio.firstName(procFio.gcaseDat));
            $('#user_iname_attributes_vp').val(procFio.firstName(procFio.gcaseVin));
            $('#user_iname_attributes_tp').val(procFio.firstName(procFio.gcaseTvor));
            $('#user_iname_attributes_pp').val(procFio.firstName(procFio.gcasePred));

            $('#user_fname_attributes_rp').val(procFio.lastName(procFio.gcaseRod));
            $('#user_fname_attributes_dp').val(procFio.lastName(procFio.gcaseDat));
            $('#user_fname_attributes_vp').val(procFio.lastName(procFio.gcaseVin));
            $('#user_fname_attributes_tp').val(procFio.lastName(procFio.gcaseTvor));
            $('#user_fname_attributes_pp').val(procFio.lastName(procFio.gcasePred));

            $('#user_oname_attributes_rp').val(procFio.middleName(procFio.gcaseRod));
            $('#user_oname_attributes_dp').val(procFio.middleName(procFio.gcaseDat));
            $('#user_oname_attributes_vp').val(procFio.middleName(procFio.gcaseVin));
            $('#user_oname_attributes_tp').val(procFio.middleName(procFio.gcaseTvor));
            $('#user_oname_attributes_pp').val(procFio.middleName(procFio.gcasePred));
        }
    });


    /**
     * Проверяем на заполненность ФИО в именительном падеже.
     */
    function checkStudentFill() {
        return (
            $('#person_fname_attributes_ip').val() &&
                $('#person_iname_attributes_ip').val() &&
                $('#person_oname_attributes_ip').val()
            );
    }

    $('#form-student-fio input').on('blur', function() {
        if (checkStudentFill()) {
            var fio =
                $('#person_fname_attributes_ip').val()
                    + ' ' + $('#person_iname_attributes_ip').val()
                    + ' ' + $('#person_oname_attributes_ip').val();
            var procFio = new RussianName(fio);
            $('#person_iname_attributes_rp').val(procFio.firstName(procFio.gcaseRod));
            $('#person_iname_attributes_dp').val(procFio.firstName(procFio.gcaseDat));
            $('#person_iname_attributes_vp').val(procFio.firstName(procFio.gcaseVin));
            $('#person_iname_attributes_tp').val(procFio.firstName(procFio.gcaseTvor));
            $('#person_iname_attributes_pp').val(procFio.firstName(procFio.gcasePred));

            $('#person_fname_attributes_rp').val(procFio.lastName(procFio.gcaseRod));
            $('#person_fname_attributes_dp').val(procFio.lastName(procFio.gcaseDat));
            $('#person_fname_attributes_vp').val(procFio.lastName(procFio.gcaseVin));
            $('#person_fname_attributes_tp').val(procFio.lastName(procFio.gcaseTvor));
            $('#person_fname_attributes_pp').val(procFio.lastName(procFio.gcasePred));

            $('#person_oname_attributes_rp').val(procFio.middleName(procFio.gcaseRod));
            $('#person_oname_attributes_dp').val(procFio.middleName(procFio.gcaseDat));
            $('#person_oname_attributes_vp').val(procFio.middleName(procFio.gcaseVin));
            $('#person_oname_attributes_tp').val(procFio.middleName(procFio.gcaseTvor));
            $('#person_oname_attributes_pp').val(procFio.middleName(procFio.gcasePred));
        }
    });

});