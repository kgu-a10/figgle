#region License

// Copyright 2017 Drew Noakes
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#endregion

namespace Figgle
{
    internal static class ParseUtil
    {
        public static bool TryParse(string s, out int i)
        {
            const int starting = 0;
            const int leadingZero = 1;
            const int dec = 2;
            const int oct = 3;
            const int startingHex = 4;
            const int hex = 5;

            var state = starting;
            var value = 0;

            // ReSharper disable once ForCanBeConvertedToForeach
            for (var idx = 0; idx < s.Length; idx++)
            {
                var c = s[idx];

                switch (state)
                {
                    case starting:
                    {
                        switch (c)
                        {
                            case '0':
                                state = leadingZero;
                                break;
                            default:
                                if (char.IsWhiteSpace(c))
                                    break;
                                if (char.IsDigit(c))
                                {
                                    value = c - '0';
                                    state = dec;
                                    break;
                                }
                                i = default(int);
                                return false;
                        }
                        break;
                    }
                    case leadingZero:
                    {
                        switch (c)
                        {
                            case 'x':
                            case 'X':
                            case 'h':
                                state = startingHex;
                                break;
                            default:
                                if (char.IsDigit(c))
                                {
                                    value = c - '0';
                                    state = oct;
                                    break;
                                }
                                i = default(int);
                                return false;
                        }
                        break;
                    }
                    case dec:
                    {
                        if (char.IsDigit(c))
                        {
                            value *= 10;
                            value += c - '0';
                            continue;
                        }
                        if (char.IsWhiteSpace(c))
                        {
                            i = value;
                            return true;
                        }
                        i = default(int);
                        return false;
                    }
                    case oct:
                    {
                        var v = c - '0';
                        if (v >= 0 && v < 8)
                        {
                            value *= 8;
                            value += v;
                            continue;
                        }
                        if (char.IsWhiteSpace(c))
                        {
                            i = value;
                            return true;
                        }
                        i = default(int);
                        return false;
                    }
                    case hex:
                    case startingHex:
                    {
                        if (c >= '0' && c <= '9')
                        {
                            state = hex;
                            var v = c - '0';
                            value *= 16;
                            value += v;
                            continue;
                        }
                        var cl = char.ToLower(c);
                        if (cl >= 'a' && c <= 'f')
                        {
                            state = hex;
                            var v = cl - 'a' + 10;
                            value *= 16;
                            value += v;
                            continue;
                        }
                        if (state == hex && char.IsWhiteSpace(c))
                        {
                            i = value;
                            return true;
                        }
                        i = default(int);
                        return false;
                    }
                }
            }

            switch (state)
            {
                case dec:
                case oct:
                case hex:
                    i = value;
                    return true;

                default:
                    i = 0;
                    return false;
            }
        }
    }
}