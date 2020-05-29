
#include <cstring>

template<typename _T>
cDynArray<_T>::cDynArray(uint _i)
	: cDynArrayBase()
{
	if (_i != 0)
	{
		_resize(&m_data, sizeof(type), _i);
		m_allocsize = _i;
	}
}

template<typename _T>
cDynArray<_T>::cDynArray(const cDynArray<_T>& _cpy)
	: cDynArrayBase()
{
	if (_cpy.m_size != 0)
	{
		_resize(&m_data, sizeof(type), _cpy.m_size);
		::memcpy(m_data, _cpy.m_data, sizeof(type) * _cpy.m_size);
		m_allocsize = m_size = _cpy.m_size;
	}
}

template<typename _T>
cDynArray<_T>& cDynArray<_T>::operator=(const cDynArray<_T>& _cpy)
{
	_resize(&m_data, sizeof(type), _cpy.m_size);
	if (_cpy.m_size)
		::memcpy(m_data, _cpy.m_data, sizeof(type) * _cpy.m_size);
	m_allocsize = m_size = _cpy.m_size;
}

template<typename _T>
_T& cDynArray<_T>::operator[](uint _n) SPEC_THROW(std::out_of_range)
{
	if (_n >= m_size)
		throw std::out_of_range("cDynArray::operator[]");
	return reinterpret_cast<ptr>(m_data)[_n];
}

template<typename _T>
const _T& cDynArray<_T>::operator[](uint _n) const SPEC_THROW(std::out_of_range)
{
	if (_n >= m_size)
		throw std::out_of_range("cDynArray::operator[]");
	return reinterpret_cast<ptr>(m_data)[_n];
}

template<typename _T>
void cDynArray<_T>::resize(uint _i)
{
	if (_i > m_allocsize)
	{
		_resize(&m_data, sizeof(type), _i);
		m_allocsize = _i;
	}
	else
	{
		if (_i < m_size)
			m_size = _i;
		if ((m_allocsize - m_size)*sizeof(type) > 4096)
		{
			_resize(&m_data, sizeof(type), m_size);
			m_allocsize = m_size;
		}
	}
}

template<typename _T>
uint cDynArray<_T>::append(const _T& _e)
{
	uint _i = m_size + 1;
	if (_i > m_allocsize)
	{
		uint _sz = (m_size < 16) ? m_size + 4 : m_size * 2;
		_resize(&m_data, sizeof(type), _sz);
		m_allocsize = _sz;
	}
	m_size = _i--;
	reinterpret_cast<ptr>(m_data)[_i] = _e;
	return _i;
}

template<typename _T>
uint cDynArray<_T>::insert(const _T& _e, uint _n)
{
	uint _i = m_size + 1;
	if (_i > m_allocsize)
	{
		uint _sz = (m_size < 16) ? m_size + 4 : m_size * 2;
		_resize(&m_data, sizeof(type), _sz);
		m_allocsize = _sz;
	}
	if (_n >= m_size)
	{
		m_size = _i--;
		reinterpret_cast<ptr>(m_data)[_i] = _e;
		return _i;
	}
	_T* _p = reinterpret_cast<ptr>(m_data) + _n;
	::memmove(_p+1, _p, (m_size - _n)*sizeof(type));
	*_p = _e;
	m_size = _i;
	return _n;
}

template<typename _T>
void cDynArray<_T>::erase(uint _n) SPEC_THROW(std::out_of_range)
{
	if (_n >= m_size)
		throw std::out_of_range("cDynArray::erase");
	--m_size;
	_T* _p = reinterpret_cast<ptr>(m_data) + _n;
	::memmove(_p, _p+1, (m_size - _n)*sizeof(type));
	if ((m_allocsize - m_size)*sizeof(type) > 4096)
	{
		_resize(&m_data, sizeof(type), m_size);
		m_allocsize = m_size;
	}
}
